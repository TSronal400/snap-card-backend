import 'dart:ui';
import 'package:flutter/material.dart';

void main() {
  runApp(const SnapCardApp());
}

// URL RAW exacta de tu repositorio de GitHub
const String miImagenGitHubUrl =
    'https://raw.githubusercontent.com/dahianamoran05-tech/Snap-Card-/main/this%20e.jpg';

class SnapCardApp extends StatelessWidget {
  const SnapCardApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SNAP CARD',
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        fontFamily: 'Arial',
      ),
      home: const WelcomeScreen(),
    );
  }
}

// ====================================================================
// 1. PANTALLA DE BIENVENIDA (CON TU CHARIZARD DE GITHUB)
// ====================================================================
class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF160B08),
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Imagen cargada directamente desde tu GitHub
          Image.network(
            miImagenGitHubUrl,
            fit: BoxFit.cover,
            alignment: Alignment.center,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return const Center(
                child: CircularProgressIndicator(
                  color: Color(0xFFEA7424),
                ),
              );
            },
            errorBuilder: (context, error, stackTrace) {
              return const DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFFED681D),
                      Color(0xFF511708),
                      Color(0xFF130907),
                    ],
                  ),
                ),
              );
            },
          ),

          // Capa de desenfoque y degradado para que el texto resalte
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 0.8, sigmaY: 0.8),
            child: Container(color: const Color(0xFF160B08).withOpacity(0.25)),
          ),
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: [0, 0.25, 0.65, 1],
                colors: [
                  Color.fromRGBO(17, 7, 4, 0.70),
                  Colors.transparent,
                  Color.fromRGBO(20, 8, 4, 0.85),
                  Color.fromRGBO(14, 7, 6, 0.98),
                ],
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(26, 22, 26, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const AppHeader(),
                  const Spacer(),
                  const Row(
                    children: [
                      SizedBox(
                        width: 25,
                        child: Divider(color: Color(0xFFFFA42C), thickness: 2),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'TU PRÓXIMA HISTORIA EMPIEZA AQUÍ',
                          style: TextStyle(
                            color: Color(0xFFFFC564),
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1.3,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  const Text(
                    'Tu colección,',
                    style: TextStyle(
                      color: Color(0xFFFFFAF3),
                      fontSize: 46,
                      height: 0.96,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -2,
                    ),
                  ),
                  const Text(
                    'tu aventura.',
                    style: TextStyle(
                      color: Color(0xFFFFB03B),
                      fontSize: 46,
                      height: 0.96,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -2,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Descubre, escanea y colecciona. Cada carta tiene una historia y valor real.',
                    style: TextStyle(
                      color: Color.fromRGBO(255, 250, 243, 0.82),
                      fontSize: 15,
                      height: 1.5,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 18),
                  const Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 9,
                    children: [
                      FeatureText('DESCUBRE'),
                      FeatureDot(),
                      FeatureText('ESCANEA'),
                      FeatureDot(),
                      FeatureText('VALORA'),
                    ],
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 58,
                    child: FilledButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AuthScreen(),
                          ),
                        );
                      },
                      style: FilledButton.styleFrom(
                        backgroundColor: const Color(0xFFFFF9EF),
                        foregroundColor: const Color(0xFF28120B),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Comenzar aventura',
                            style: TextStyle(fontWeight: FontWeight.w800),
                          ),
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [
                                  Color(0xFFF58B25),
                                  Color(0xFFC84217),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(13),
                            ),
                            child: const Icon(
                              Icons.arrow_forward,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Center(
                    child: Text(
                      'Accede a tu cuenta o regístrate para continuar',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color.fromRGBO(255, 250, 243, 0.5),
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ====================================================================
// 2. PANTALLA DE AUTENTICACIÓN
// ====================================================================
class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool isLogin = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF160B08),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFFFFFAF3)),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(26, 10, 26, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isLogin ? 'Iniciar' : 'Únete a',
                style: const TextStyle(
                  color: Color(0xFFFFFAF3),
                  fontSize: 36,
                  height: 0.96,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -1.5,
                ),
              ),
              const Text(
                'SNAP CARD.',
                style: TextStyle(
                  color: Color(0xFFFFB03B),
                  fontSize: 36,
                  height: 0.96,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -1.5,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                isLogin
                    ? 'Ingresa tus datos para ver el valor acumulado de tus cartas.'
                    : 'Completa tus datos para crear una nueva colección.',
                style: const TextStyle(
                  color: Color.fromRGBO(255, 250, 243, 0.7),
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 30),
              if (!isLogin) ...[
                const Text(
                  'NOMBRE DE COLECCIONISTA',
                  style: TextStyle(
                    color: Color(0xFFFFC564),
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Ej. Ash Ketchum',
                    hintStyle: TextStyle(color: Colors.white.withOpacity(0.3)),
                    filled: true,
                    fillColor: const Color(0xFF22110C),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
              const Text(
                'CORREO ELECTRÓNICO',
                style: TextStyle(
                  color: Color(0xFFFFC564),
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'tu@correo.com',
                  hintStyle: TextStyle(color: Colors.white.withOpacity(0.3)),
                  filled: true,
                  fillColor: const Color(0xFF22110C),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'CONTRASEÑA',
                style: TextStyle(
                  color: Color(0xFFFFC564),
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                obscureText: true,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: '••••••••',
                  hintStyle: TextStyle(color: Colors.white.withOpacity(0.3)),
                  filled: true,
                  fillColor: const Color(0xFF22110C),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 54,
                child: FilledButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SnapCardHome(),
                      ),
                    );
                  },
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFFDC611B),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Text(
                    isLogin ? 'Iniciar sesión' : 'Registrarse',
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      isLogin ? '¿No tienes cuenta?' : '¿Ya tienes una cuenta?',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.6),
                        fontSize: 13,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          isLogin = !isLogin;
                        });
                      },
                      child: Text(
                        isLogin ? 'Crear cuenta' : 'Iniciar sesión',
                        style: const TextStyle(
                          color: Color(0xFFFFB03B),
                          fontWeight: FontWeight.w800,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ====================================================================
// 3. MENÚ PRINCIPAL (5 PESTAÑAS)
// ====================================================================
class SnapCardHome extends StatefulWidget {
  const SnapCardHome({super.key});

  @override
  State<SnapCardHome> createState() => _SnapCardHomeState();
}

class _SnapCardHomeState extends State<SnapCardHome> {
  int selectedIndex = 0;

  final screens = const [
    CollectionScreen(),
    ScannerScreen(),
    SearchScreen(),
    AIAssistantScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF120A08),
      body: IndexedStack(
        index: selectedIndex,
        children: screens,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIndex,
        height: 72,
        backgroundColor: const Color(0xFF21120E),
        indicatorColor: const Color(0xFFEA7424),
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        onDestinationSelected: (index) {
          setState(() {
            selectedIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.style_outlined),
            selectedIcon: Icon(Icons.style),
            label: 'Colección',
          ),
          NavigationDestination(
            icon: Icon(Icons.center_focus_strong_outlined),
            selectedIcon: Icon(Icons.center_focus_strong),
            label: 'Escanear',
          ),
          NavigationDestination(
            icon: Icon(Icons.search_outlined),
            selectedIcon: Icon(Icons.search),
            label: 'Lupa',
          ),
          NavigationDestination(
            icon: Icon(Icons.auto_awesome_outlined),
            selectedIcon: Icon(Icons.auto_awesome),
            label: 'IA Bot',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Perfil',
          ),
        ],
      ),
    );
  }
}

// ====================================================================
// 4. PANTALLA DE COLECCIÓN CON VALOR ACUMULADO
// ====================================================================
class CollectionScreen extends StatelessWidget {
  const CollectionScreen({super.key});

  static const cards = [
    CardData(
      name: 'Charizard Fuego Divino',
      category: 'Legendaria',
      price: 350.00,
      icon: Icons.local_fire_department,
      colors: [Color(0xFFEA7022), Color(0xFF8A250F)],
    ),
    CardData(
      name: 'Guardián del Mar',
      category: 'Épica',
      price: 85.50,
      icon: Icons.water_drop,
      colors: [Color(0xFF1685B8), Color(0xFF0B3A70)],
    ),
    CardData(
      name: 'Bosque Antiguo',
      category: 'Rara',
      price: 25.00,
      icon: Icons.forest,
      colors: [Color(0xFF3E9B4F), Color(0xFF174C2C)],
    ),
    CardData(
      name: 'Tormenta Eléctrica',
      category: 'Épica',
      price: 110.00,
      icon: Icons.bolt,
      colors: [Color(0xFFF4B82D), Color(0xFF9B5515)],
    ),
    CardData(
      name: 'Sombra Nocturna',
      category: 'Rara',
      price: 45.00,
      icon: Icons.nightlight_round,
      colors: [Color(0xFF7759B8), Color(0xFF281848)],
    ),
    CardData(
      name: 'Cristal Mágico',
      category: 'Especial',
      price: 190.00,
      icon: Icons.diamond,
      colors: [Color(0xFFDD59A4), Color(0xFF712A67)],
    ),
  ];

  double get totalPrice {
    return cards.fold(0, (sum, card) => sum + card.price);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const AppHeader(),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF29150F), Color(0xFF1A0D0A)],
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFFFFA33B).withOpacity(0.3)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.4),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: const Color(0xFFEA7424).withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.attach_money,
                      color: Color(0xFFFFB03B),
                      size: 30,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'VALOR TOTAL ACUMULADO',
                        style: TextStyle(
                          color: Color(0xFFFFC564),
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1.1,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '\$${totalPrice.toStringAsFixed(2)} USD',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Mi colección',
              style: TextStyle(
                color: Color(0xFFFFFAF3),
                fontSize: 26,
                fontWeight: FontWeight.w900,
                letterSpacing: -1,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              '6 de 120 cartas descubiertas',
              style: TextStyle(
                color: Color.fromRGBO(255, 250, 243, 0.6),
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 14),
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: const LinearProgressIndicator(
                value: 0.05,
                minHeight: 8,
                backgroundColor: Color(0xFF33201A),
                valueColor: AlwaysStoppedAnimation(
                  Color(0xFFEF812B),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final columns = constraints.maxWidth > 600 ? 3 : 2;

                  return GridView.builder(
                    itemCount: cards.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: columns,
                      crossAxisSpacing: 14,
                      mainAxisSpacing: 14,
                      childAspectRatio: 0.70,
                    ),
                    itemBuilder: (context, index) {
                      return CollectionCard(
                        card: cards[index],
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CardData {
  final String name;
  final String category;
  final double price;
  final IconData icon;
  final List<Color> colors;

  const CardData({
    required this.name,
    required this.category,
    required this.price,
    required this.icon,
    required this.colors,
  });
}

class CollectionCard extends StatelessWidget {
  final CardData card;

  const CollectionCard({
    super.key,
    required this.card,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: card.colors,
        ),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: Colors.white.withOpacity(0.12),
        ),
        boxShadow: [
          BoxShadow(
            color: card.colors.last.withOpacity(0.4),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '\$${card.price.toStringAsFixed(0)}',
                    style: const TextStyle(
                      color: Color(0xFFFFD17A),
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                Icon(
                  Icons.auto_awesome,
                  color: Colors.white.withOpacity(0.7),
                  size: 16,
                ),
              ],
            ),
            const Spacer(),
            Icon(
              card.icon,
              size: 58,
              color: Colors.white,
            ),
            const Spacer(),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                card.category.toUpperCase(),
                style: TextStyle(
                  color: Colors.white.withOpacity(0.7),
                  fontSize: 9,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1,
                ),
              ),
            ),
            const SizedBox(height: 4),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                card.name,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  height: 1.1,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ====================================================================
// 5. PANTALLA DEL ESCÁNER
// ====================================================================
class ScannerScreen extends StatelessWidget {
  const ScannerScreen({super.key});

  void simulateScan(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('¡Carta detectada! Charizard (+ \$350 USD)'),
        backgroundColor: Color(0xFFDC611B),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
        child: Column(
          children: [
            const AppHeader(),
            const SizedBox(height: 28),
            const Text(
              'Escanea una carta',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFFFFFAF3),
                fontSize: 30,
                fontWeight: FontWeight.w900,
                letterSpacing: -1,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Apunta a tu carta física para registrar su precio',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color.fromRGBO(255, 250, 243, 0.6),
                fontSize: 14,
              ),
            ),
            const Spacer(),
            Container(
              width: 270,
              height: 370,
              decoration: BoxDecoration(
                color: const Color(0xFF21120E),
                borderRadius: BorderRadius.circular(28),
                border: Border.all(
                  color: const Color(0xFFFFA33B),
                  width: 3,
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFFF8D24).withOpacity(0.3),
                    blurRadius: 30,
                  ),
                ],
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Icon(
                    Icons.style,
                    size: 100,
                    color: Colors.white.withOpacity(0.1),
                  ),
                  Container(
                    height: 2,
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.transparent,
                          Color(0xFFFFB13B),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                  const Positioned(
                    bottom: 24,
                    child: Row(
                      children: [
                        Icon(
                          Icons.lightbulb_outline,
                          color: Color(0xFFFFBD64),
                          size: 17,
                        ),
                        SizedBox(width: 6),
                        Text(
                          'Busca una buena iluminación',
                          style: TextStyle(
                            color: Color(0xFFFFBD64),
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: FilledButton.icon(
                onPressed: () => simulateScan(context),
                icon: const Icon(Icons.center_focus_strong),
                label: const Text(
                  'Simular escaneo',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFFEC7624),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ====================================================================
// 6. PANTALLA DE LUPA / BÚSQUEDA EXCLUSIVA
// ====================================================================
class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const AppHeader(),
            const SizedBox(height: 28),
            const Text(
              'Búsqueda',
              style: TextStyle(
                color: Color(0xFFFFFAF3),
                fontSize: 30,
                fontWeight: FontWeight.w900,
                letterSpacing: -1,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Encuentra cartas en la base de datos por nombre o categoría',
              style: TextStyle(
                color: Color.fromRGBO(255, 250, 243, 0.6),
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 24),
            TextField(
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Buscar cartas...',
                hintStyle: TextStyle(color: Colors.white.withOpacity(0.3)),
                prefixIcon: const Icon(Icons.search, color: Color(0xFFFFB13B)),
                filled: true,
                fillColor: const Color(0xFF21120E),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const Spacer(),
            const Center(
              child: Icon(
                Icons.search,
                size: 80,
                color: Color(0xFF21120E),
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}

// ====================================================================
// 7. PANTALLA DE IA INDEPENDIENTE (IA BOT)
// ====================================================================
class AIAssistantScreen extends StatelessWidget {
  const AIAssistantScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const AppHeader(),
            const SizedBox(height: 28),
            const Row(
              children: [
                Icon(Icons.auto_awesome, color: Color(0xFFFFB03B), size: 28),
                SizedBox(width: 10),
                Text(
                  'Asistente IA Snap',
                  style: TextStyle(
                    color: Color(0xFFFFFAF3),
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -1,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Text(
              'Consulta precios del mercado, autenticidad y consejos para tu colección',
              style: TextStyle(
                color: Color.fromRGBO(255, 250, 243, 0.6),
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: const Color(0xFF21120E),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white.withOpacity(0.08)),
              ),
              child: const Text(
                'Hola Coleccionista. ¿En qué te puedo ayudar hoy? Puedo analizar el valor estimado de tu Charizard o sugerirte nuevas cartas.',
                style: TextStyle(
                  color: Color(0xFFFFFAF3),
                  fontSize: 14,
                  height: 1.4,
                ),
              ),
            ),
            const Spacer(),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Pregunta sobre tus cartas...',
                      hintStyle: TextStyle(color: Colors.white.withOpacity(0.3)),
                      filled: true,
                      fillColor: const Color(0xFF21120E),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  height: 52,
                  width: 52,
                  decoration: BoxDecoration(
                    color: const Color(0xFFEA7424),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.send, color: Colors.white),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Procesando consulta con la IA...'),
                          backgroundColor: Color(0xFFEA7424),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ====================================================================
// 8. PANTALLA DE PERFIL
// ====================================================================
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 30),
        children: [
          const AppHeader(),
          const SizedBox(height: 32),
          Center(
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFFFF9A31),
                    Color(0xFFC84217),
                  ],
                ),
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white.withOpacity(0.7),
                  width: 3,
                ),
              ),
              child: const Icon(
                Icons.person,
                color: Colors.white,
                size: 54,
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Coleccionista',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFFFFFAF3),
              fontSize: 24,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Coleccionista de Aventuras',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color.fromRGBO(255, 250, 243, 0.55),
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 28),
          const Row(
            children: [
              Expanded(
                child: ProfileStat(
                  value: '6',
                  label: 'Cartas',
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: ProfileStat(
                  value: '\$801',
                  label: 'Valor total',
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: ProfileStat(
                  value: '5%',
                  label: 'Completado',
                ),
              ),
            ],
          ),
          const SizedBox(height: 28),
          const Text(
            'Mi cuenta',
            style: TextStyle(
              color: Color(0xFFFFFAF3),
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 12),
          const ProfileOption(
            icon: Icons.edit_outlined,
            title: 'Editar perfil',
          ),
          const ProfileOption(
            icon: Icons.notifications_outlined,
            title: 'Notificaciones',
          ),
          const ProfileOption(
            icon: Icons.palette_outlined,
            title: 'Apariencia',
          ),
          const ProfileOption(
            icon: Icons.help_outline,
            title: 'Ayuda y soporte',
          ),
          const ProfileOption(
            icon: Icons.info_outline,
            title: 'Acerca de SNAP CARD',
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: OutlinedButton.icon(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const WelcomeScreen(),
                  ),
                );
              },
              icon: const Icon(Icons.logout, color: Color(0xFFEA7424)),
              label: const Text(
                'Cerrar sesión',
                style: TextStyle(
                  color: Color(0xFFFFFAF3),
                  fontWeight: FontWeight.w800,
                ),
              ),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Color(0xFFEA7424)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ProfileStat extends StatelessWidget {
  final String value;
  final String label;

  const ProfileStat({
    super.key,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 18,
        horizontal: 8,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFF21120E),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: Colors.white.withOpacity(0.08),
        ),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              color: Color(0xFFFFA33B),
              fontSize: 20,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              color: Color.fromRGBO(255, 250, 243, 0.55),
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}

class ProfileOption extends StatelessWidget {
  final IconData icon;
  final String title;

  const ProfileOption({
    super.key,
    required this.icon,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFF21120E),
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: const Color(0xFFFFA33B),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
        trailing: const Icon(
          Icons.chevron_right,
          color: Colors.white54,
        ),
        onTap: () {},
      ),
    );
  }
}

// ====================================================================
// 9. ENCABEZADO COMPARTIDO
// ====================================================================
class AppHeader extends StatelessWidget {
  const AppHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Icon(
          Icons.auto_awesome,
          color: Color(0xFFFFB13B),
        ),
        SizedBox(width: 10),
        Text(
          'SNAP CARD',
          style: TextStyle(
            color: Color(0xFFFFFAF3),
            fontSize: 17,
            fontWeight: FontWeight.w900,
            letterSpacing: 2,
          ),
        ),
      ],
    );
  }
}

class FeatureText extends StatelessWidget {
  final String text;
  const FeatureText(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        color: Color.fromRGBO(255, 250, 243, 0.62),
        fontSize: 10,
        fontWeight: FontWeight.w700,
        letterSpacing: 1,
      ),
    );
  }
}

class FeatureDot extends StatelessWidget {
  const FeatureDot({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 3,
      height: 3,
      decoration: const BoxDecoration(
        color: Color(0xFFF69829),
        shape: BoxShape.circle,
      ),
    );
  }
}