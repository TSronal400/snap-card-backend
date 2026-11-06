
from typing import List
from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy import select, text
from sqlalchemy.orm import Session

from app.database import get_db
from app.dependencies import get_current_user
from app.models import User, Card, UserCollection, TcgdexUserCollection
from app.schemas import CardResponse
from app.services.tcgdex_service import (
    get_tcgdex_card_details,
    convert_eur_to_dop
)


router = APIRouter(prefix="/collection", tags=["Colección de Usuario"])


@router.get("", response_model=List[CardResponse])
def get_user_collection(
    user: User = Depends(get_current_user),
    db: Session = Depends(get_db)
):
    collection_items = db.scalars(
        select(UserCollection).where(UserCollection.user_id == user.id)
    ).all()

    card_ids = [item.card_id for item in collection_items]

    if not card_ids:
        return []

    cards = db.scalars(
        select(Card).where(Card.id.in_(card_ids))
    ).all()

    return cards


@router.post("/add", status_code=status.HTTP_201_CREATED)
def add_card_to_collection(
    data: dict,
    user: User = Depends(get_current_user),
    db: Session = Depends(get_db)
):
    card_id = data.get("card_id")

    if not card_id:
        raise HTTPException(
            status_code=400,
            detail="Se requiere el ID de la carta"
        )

    card = db.get(Card, int(card_id))

    if not card:
        raise HTTPException(
            status_code=404,
            detail="Carta no encontrada en la base de datos"
        )

    existing = db.scalar(
        select(UserCollection).where(
            UserCollection.user_id == user.id,
            UserCollection.card_id == card.id
        )
    )

    if existing:
        return {
            "message": "La carta ya está en tu colección",
            "card_id": card.id
        }

    item = UserCollection(
        user_id=user.id,
        card_id=card.id
    )

    db.add(item)
    db.commit()

    return {
        "message": "¡Carta añadida a tu colección con éxito!",
        "card_id": card.id,
        "card_name": card.name
    }


@router.delete("/{card_id}", status_code=status.HTTP_200_OK)
def remove_card_from_collection(
    card_id: int,
    user: User = Depends(get_current_user),
    db: Session = Depends(get_db)
):
    item = db.scalar(
        select(UserCollection).where(
            UserCollection.user_id == user.id,
            UserCollection.card_id == card_id
        )
    )

    if not item:
        raise HTTPException(
            status_code=404,
            detail="La carta no está en tu colección"
        )

    db.delete(item)
    db.commit()

    return {
        "message": "Carta eliminada de la colección con éxito"
    }


@router.get("/tcgdex")
def get_tcgdex_collection(
    user: User = Depends(get_current_user),
    db: Session = Depends(get_db)
):
    query = text("""
        SELECT c.id, c.name, c.category, c.rarity, c.image,
               c.local_id, c.set_id, c.set_name, c.hp,
               c.types, c.stage, c.illustrator,
               uc.price
        FROM public.tcgdex_cards c
        INNER JOIN public.tcgdex_user_collections uc
            ON uc.tcgdex_card_id = c.id
        WHERE uc.user_id = :user_id
        ORDER BY uc.acquired_at DESC
    """)

    result = db.execute(
        query,
        {"user_id": user.id}
    )

    return [dict(row) for row in result.mappings().all()]


@router.post("/tcgdex/add", status_code=status.HTTP_201_CREATED)
def add_tcgdex_card(
    data: dict,
    user: User = Depends(get_current_user),
    db: Session = Depends(get_db)
):
    card_id = data.get("card_id")

    if not card_id:
        raise HTTPException(
            status_code=400,
            detail="Se requiere el ID de la carta"
        )

    card = db.execute(
        text("""
            SELECT id, name
            FROM public.tcgdex_cards
            WHERE id = :card_id
        """),
        {"card_id": str(card_id)}
    ).mappings().first()

    if not card:
        raise HTTPException(
            status_code=404,
            detail="Carta TCGdex no encontrada"
        )

    existing = db.execute(
        text("""
            SELECT id
            FROM public.tcgdex_user_collections
            WHERE user_id = :user_id
            AND tcgdex_card_id = :card_id
        """),
        {
            "user_id": user.id,
            "card_id": str(card_id)
        }
    ).first()

    if existing:
        return {
            "message": "La carta ya está en tu colección",
            "card_id": card_id
        }

    # Obtener el precio de TCGdex
    price = None

    try:
        details = get_tcgdex_card_details(str(card_id))
        pricing = details.get("pricing") or {}
        cardmarket = pricing.get("cardmarket") or {}

        price = cardmarket.get("avg")

        # Si no existe precio general, buscarlo en las variantes
        if price is None:
            for variant in details.get("variants_detailed") or []:
                variant_pricing = variant.get("pricing") or {}
                variant_cardmarket = variant_pricing.get("cardmarket") or {}

                price = variant_cardmarket.get("avg")

                if price is not None:
                    break

        # Convertir de euros a pesos dominicanos
        if price is not None:
            price = convert_eur_to_dop(price)

    except Exception as e:
        print(f"Error obteniendo precio TCGdex: {e}")

    # Guardar la carta y su precio
    db.add(
        TcgdexUserCollection(
            user_id=user.id,
            tcgdex_card_id=str(card_id),
            price=price
        )
    )

    db.commit()

    return {
        "message": "¡Carta añadida a tu colección!",
        "card_id": card_id,
        "card_name": card["name"],
        "price": price
    }


@router.delete("/tcgdex/{card_id}")
def remove_tcgdex_card(
    card_id: str,
    user: User = Depends(get_current_user),
    db: Session = Depends(get_db)
):
    item = db.execute(
        select(TcgdexUserCollection).where(
            TcgdexUserCollection.user_id == user.id,
            TcgdexUserCollection.tcgdex_card_id == card_id
        )
    ).scalar_one_or_none()

    if not item:
        raise HTTPException(
            status_code=404,
            detail="La carta no está en tu colección"
        )

    db.delete(item)
    db.commit()

    return {
        "message": "Carta eliminada de tu colección"
    }


    
# ==========================================
# CARTAS DESEADAS (TCGdex)
# ==========================================

@router.get("/wishlist")
def get_tcgdex_wishlist(
    user: User = Depends(get_current_user),
    db: Session = Depends(get_db)
):
    query = text("""
        SELECT
            c.id,
            c.name,
            c.category,
            c.rarity,
            c.image,
            c.local_id,
            c.set_id,
            c.set_name,
            c.hp,
            c.types,
            c.stage,
            c.illustrator
        FROM public.tcgdex_cards c
        INNER JOIN public.tcgdex_user_wishlists w
            ON w.tcgdex_card_id = c.id
        WHERE w.user_id = :user_id
        ORDER BY w.created_at DESC
    """)

    result = db.execute(
        query,
        {"user_id": user.id}
    )

    return [dict(row) for row in result.mappings().all()]


@router.post("/wishlist/add", status_code=status.HTTP_201_CREATED)
def add_tcgdex_card_to_wishlist(
    data: dict,
    user: User = Depends(get_current_user),
    db: Session = Depends(get_db)
):
    card_id = data.get("card_id")

    if not card_id:
        raise HTTPException(
            status_code=400,
            detail="Se requiere el ID de la carta"
        )

    card = db.execute(
        text("""
            SELECT id, name
            FROM public.tcgdex_cards
            WHERE id = :card_id
        """),
        {"card_id": str(card_id)}
    ).mappings().first()

    if not card:
        raise HTTPException(
            status_code=404,
            detail="Carta TCGdex no encontrada"
        )

    existing = db.execute(
        text("""
            SELECT id
            FROM public.tcgdex_user_wishlists
            WHERE user_id = :user_id
            AND tcgdex_card_id = :card_id
        """),
        {
            "user_id": user.id,
            "card_id": str(card_id)
        }
    ).first()

    if existing:
        return {
            "message": "La carta ya está en Cartas deseadas",
            "card_id": card_id
        }

    db.execute(
        text("""
            INSERT INTO public.tcgdex_user_wishlists
                (user_id, tcgdex_card_id)
            VALUES
                (:user_id, :card_id)
        """),
        {
            "user_id": user.id,
            "card_id": str(card_id)
        }
    )

    db.commit()

    return {
        "message": "¡Carta añadida a Cartas deseadas!",
        "card_id": card_id,
        "card_name": card["name"]
    }


@router.delete("/wishlist/{card_id}")
def remove_tcgdex_card_from_wishlist(
    card_id: str,
    user: User = Depends(get_current_user),
    db: Session = Depends(get_db)
):
    result = db.execute(
        text("""
            DELETE FROM public.tcgdex_user_wishlists
            WHERE user_id = :user_id
            AND tcgdex_card_id = :card_id
        """),
        {
            "user_id": user.id,
            "card_id": card_id
        }
    )

    if result.rowcount == 0:
        raise HTTPException(
            status_code=404,
            detail="La carta no está en Cartas deseadas"
        )

    db.commit()

    return {
        "message": "Carta eliminada de Cartas deseadas"
    }

