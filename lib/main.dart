import 'dart:ui';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'models/tcgdex_card.dart';
import 'package:image_picker/image_picker.dart';
import 'models/user.dart';
import 'models/card_item.dart';
import 'services/api_service.dart';
import 'dart:async';

void main() {
  runApp(const SnapCardApp());
}

// URL RAW exacta de tu repositorio de GitHub
const String miImagenGitHubUrl =
    'https://raw.githubusercontent.com/dahianamoran05-tech/Snap-Card-/main/this%20e.jpg';
class AppHeader extends StatelessWidget {
  const AppHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFFFFB13B), Color(0xFFE65B19)],
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(
            Icons.style_rounded,
            color: Colors.white,
            size: 25,
          ),
        ),
        const SizedBox(width: 10),
        const Text(
          'SNAP CARD',
          style: TextStyle(
            color: Colors.white,
            fontSize: 19,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.2,
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
        color: Color(0xFFFFB13B),
        fontSize: 10,
        fontWeight: FontWeight.bold,
        letterSpacing: 1.1,
      ),
    );
  }
}

class FeatureDot extends StatelessWidget {
  const FeatureDot({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 4,
      height: 4,
      decoration: const BoxDecoration(
        color: Color(0xFFFFB13B),
        shape: BoxShape.circle,
      ),
    );
  }
}

class ThemeParams {
  final bool isDarkMode;
  final String themeColor;

  const ThemeParams({
    this.isDarkMode = true,
    this.themeColor = 'orange',
  });

  Color get primaryColor {
    switch (themeColor) {
      case 'red':
        return const Color(0xFFD32F2F);
      case 'blue':
        return const Color(0xFF1976D2);
      case 'green':
        return const Color(0xFF388E3C);
      case 'purple':
        return const Color(0xFF7B1FA2);
      case 'orange':
      default:
        return const Color(0xFFEA7424);
    }
  }

  Color get accentColor {
    switch (themeColor) {
      case 'red':
        return const Color(0xFFFF5252);
      case 'blue':
        return const Color(0xFF448AFF);
      case 'green':
        return const Color(0xFF69F0AE);
      case 'purple':
        return const Color(0xFFE040FB);
      case 'orange':
      default:
        return const Color(0xFFFFA33B);
    }
  }

  ThemeParams copyWith({
    bool? isDarkMode,
    String? themeColor,
  }) {
    return ThemeParams(
      isDarkMode: isDarkMode ?? this.isDarkMode,
      themeColor: themeColor ?? this.themeColor,
    );
  }
}

final ValueNotifier<ThemeParams> appThemeNotifier = ValueNotifier(const ThemeParams());

class SnapCardApp extends StatefulWidget {
  const SnapCardApp({super.key});

  @override
  State<SnapCardApp> createState() => _SnapCardAppState();
}

class _SnapCardAppState extends State<SnapCardApp> {
  @override
  void initState() {
    super.initState();
    _loadThemeSettings();
  }

  Future<void> _loadThemeSettings() async {
    final isDark = await ApiService.getDarkMode();
    final color = await ApiService.getThemeColor();
    appThemeNotifier.value = ThemeParams(isDarkMode: isDark, themeColor: color);
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeParams>(
      valueListenable: appThemeNotifier,
      builder: (context, themeParams, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'SNAP CARD',
          themeMode: themeParams.isDarkMode ? ThemeMode.dark : ThemeMode.light,
          theme: ThemeData(
            useMaterial3: true,
            brightness: Brightness.light,
            primaryColor: themeParams.primaryColor,
            colorScheme: ColorScheme.light(
              primary: themeParams.primaryColor,
              secondary: themeParams.accentColor,
            ),
            fontFamily: 'Arial',
          ),
          darkTheme: ThemeData(
            useMaterial3: true,
            brightness: Brightness.dark,
            primaryColor: themeParams.primaryColor,
            scaffoldBackgroundColor: const Color(0xFF160B08),
            colorScheme: ColorScheme.dark(
              primary: themeParams.primaryColor,
              secondary: themeParams.accentColor,
            ),
            fontFamily: 'Arial',
          ),
          home: const WelcomeScreen(),
        );
      },
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
                  AppHeader(),
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
                  Wrap(
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
  bool isLoading = false;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final email = emailController.text.trim();
    final password = passwordController.text;
    final name = nameController.text.trim();

    if (email.isEmpty || password.isEmpty || (!isLogin && name.isEmpty)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor completa todos los campos required'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      if (isLogin) {
        await ApiService.login(email: email, password: password);
      } else {
        await ApiService.register(name: name, email: email, password: password);
      }

      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const SnapCardHome(),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
          backgroundColor: Colors.redAccent,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

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
                  controller: nameController,
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
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
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
                controller: passwordController,
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
                  onPressed: isLoading ? null : _submit,
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFFDC611B),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: isLoading
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2.5,
                          ),
                        )
                      : Text(
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

class CollectionScreen extends StatefulWidget {
  const CollectionScreen({super.key});

  @override
  State<CollectionScreen> createState() => _CollectionScreenState();
}

class _CollectionScreenState extends State<CollectionScreen> {
  List<dynamic> collection = [];
  List<TcgdexCard> wishlist = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCollection();
  }

  Future<void> _loadCollection() async {
    if (mounted) {
      setState(() => isLoading = true);
    }

    List<CardItem> normalCards = [];
    List<TcgdexCard> tcgdexCards = [];
    List<TcgdexCard> wishlistCards = [];

    try {
      normalCards = await ApiService.getUserCollection();
    } catch (e) {
      debugPrint('Error cargando cartas normales: $e');
    }

    try {
      tcgdexCards = await ApiService.getTcgdexCollection();
    } catch (e) {
      debugPrint('Error cargando cartas TCGdex: $e');
    }

    try {
      wishlistCards = await ApiService.getTcgdexWishlist();
    } catch (e) {
      debugPrint('Error cargando cartas deseadas: $e');
    }

    if (mounted) {
      setState(() {
        collection = [...normalCards, ...tcgdexCards];
        wishlist = wishlistCards;
        isLoading = false;
      });
    }
  }

  double get totalPrice => collection
      .whereType<CardItem>()
      .fold<double>(0, (sum, card) => sum + card.price);

void _showCardDetails(dynamic card) {
  final bool isTcgdex = card is TcgdexCard;

  final String imageUrl = card.imageUrl;
  final String name = card.name;
  final String category = card.category;

  final List<MapEntry<String, String>> details = isTcgdex
      ? [
          MapEntry('Rareza', card.rarity),
          MapEntry('HP', card.hp?.toString() ?? 'No disponible'),
          MapEntry(
            'Tipos',
            card.types.isEmpty ? 'No disponible' : card.types.join(', '),
          ),
          MapEntry('Etapa', card.stage),
          MapEntry('Expansión', card.setName),
          MapEntry('Número', card.localId),
          MapEntry('Ilustrador', card.illustrator),
        ]
      : [
          MapEntry('Tipo elemental', card.elementType),
          MapEntry('Precio', '\$${card.price.toStringAsFixed(2)} USD'),
          MapEntry('Descripción', card.description),
        ];

  showDialog(
    context: context,
    builder: (dialogContext) {
      return Dialog(
        backgroundColor: const Color(0xFF21120E),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  icon: const Icon(Icons.close, color: Colors.white70),
                ),
              ),
              if (imageUrl.isNotEmpty)
  InteractiveViewer(
    minScale: 1,
    maxScale: 5,
    child: Image.network(
      imageUrl,
      height: 260,
      fit: BoxFit.contain,
      errorBuilder: (_, __, ___) => const Icon(
        Icons.style,
        size: 100,
        color: Colors.white54,
      ),
    ),
  )
else
  const Icon(Icons.style, size: 100, color: Colors.white54),
              const SizedBox(height: 16),
              Text(
                name,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                category,
                style: const TextStyle(
                  color: Color(0xFFFFB03B),
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 18),
              ...details.where((item) => item.value.trim().isNotEmpty).map(
                (item) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 2,
                        child: Text(
                          item.key,
                          style: const TextStyle(color: Colors.white60),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Text(
                          item.value,
                          textAlign: TextAlign.end,
                          style: const TextStyle(
                            color: Colors.white,
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
        ),
      );
    },
  );
}

  void _confirmDeleteCard(dynamic card) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF21120E),
          title: const Text(
            'Eliminar Carta',
            style: TextStyle(color: Color(0xFFFFFAF3)),
          ),
          content: Text(
            '¿Estás seguro de que deseas eliminar "${card.name}" de tu colección?',
            style: const TextStyle(color: Colors.white70),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'Cancelar',
                style: TextStyle(color: Colors.white54),
              ),
            ),
            FilledButton(
              onPressed: () async {
                Navigator.pop(context);

                try {
                  if (card is TcgdexCard) {
                    await ApiService.removeTcgdexCardFromCollection(
                      card.id,
                    );
                  } else {
                    await ApiService.removeCardFromCollection(
                      (card as CardItem).id,
                    );
                  }

                  await _loadCollection();

                  if (!mounted) return;

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Carta eliminada de la colección'),
                      backgroundColor: Color(0xFFEA7424),
                    ),
                  );
                } catch (e) {
                  if (!mounted) return;

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(e.toString()),
                      backgroundColor: Colors.redAccent,
                    ),
                  );
                }
              },
              style: FilledButton.styleFrom(
                backgroundColor: Colors.redAccent,
              ),
              child: const Text('Eliminar'),
            ),
          ],
        );
      },
    );
  }

  void _confirmDeleteWishlistCard(TcgdexCard card) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF21120E),
          title: const Text(
            'Eliminar Carta Deseada',
            style: TextStyle(color: Color(0xFFFFFAF3)),
          ),
          content: Text(
            '¿Estás seguro de que deseas eliminar "${card.name}" de Cartas deseadas?',
            style: const TextStyle(color: Colors.white70),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'Cancelar',
                style: TextStyle(color: Colors.white54),
              ),
            ),
            FilledButton(
              onPressed: () async {
                Navigator.pop(context);

                try {
                  await ApiService.removeTcgdexCardFromWishlist(
                    card.id,
                  );

                  await _loadCollection();

                  if (!mounted) return;

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Carta eliminada de Cartas deseadas'),
                      backgroundColor: Color(0xFFEA7424),
                    ),
                  );
                } catch (e) {
                  if (!mounted) return;

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(e.toString()),
                      backgroundColor: Colors.redAccent,
                    ),
                  );
                }
              },
              style: FilledButton.styleFrom(
                backgroundColor: Colors.redAccent,
              ),
              child: const Text('Eliminar'),
            ),
          ],
        );
      },
    );
  }

  IconData _getElementIcon(String elementType) {
    switch (elementType.toLowerCase()) {
      case 'fuego':
        return Icons.local_fire_department;
      case 'agua':
        return Icons.water_drop;
      case 'planta':
        return Icons.forest;
      case 'electrico':
        return Icons.bolt;
      case 'psiquico':
        return Icons.auto_awesome;
      default:
        return Icons.style;
    }
  }

  List<Color> _getElementColors(String elementType) {
    switch (elementType.toLowerCase()) {
      case 'fuego':
        return const [Color(0xFFEA7022), Color(0xFF8A250F)];
      case 'agua':
        return const [Color(0xFF1685B8), Color(0xFF0B3A70)];
      case 'planta':
        return const [Color(0xFF3E9B4F), Color(0xFF174C2C)];
      case 'electrico':
        return const [Color(0xFFF4B82D), Color(0xFF9B5515)];
      case 'psiquico':
        return const [Color(0xFF7759B8), Color(0xFF281848)];
      default:
        return const [Color(0xFFDD59A4), Color(0xFF712A67)];
    }
  }

  Widget _buildWishlistCard(TcgdexCard card) {
    final colors = _getElementColors('normal');

    return GestureDetector(
      onTap: () => _showCardDetails(card),
      child: Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: colors,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withOpacity(0.12),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'DESEADA',
                    style: TextStyle(
                      color: Color(0xFFFFD17A),
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => _confirmDeleteWishlistCard(card),
                  child: Icon(
                    Icons.delete_outline,
                    color: Colors.white.withOpacity(0.8),
                    size: 18,
                  ),
                ),
              ],
            ),
            const Spacer(),
            Expanded(
              flex: 4,
              child: Center(
                child: card.imageUrl.isNotEmpty
                    ? Image.network(
                        card.imageUrl,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(
                            Icons.style,
                            size: 52,
                            color: Colors.white,
                          );
                        },
                      )
                    : const Icon(
                        Icons.style,
                        size: 52,
                        color: Colors.white,
                      ),
              ),
            ),
            const Spacer(),
            Text(
              card.category.toUpperCase(),
              style: TextStyle(
                color: Colors.white.withOpacity(0.7),
                fontSize: 9,
                fontWeight: FontWeight.w700,
                letterSpacing: 1,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              card.name,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
                height: 1.1,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
       ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppHeader(),
            const SizedBox(height: 24),

            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFF29150F),
                    Color(0xFF1A0D0A),
                  ],
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: const Color(0xFFFFA33B).withOpacity(0.3),
                ),
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

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Mi colección',
                  style: TextStyle(
                    color: Color(0xFFFFFAF3),
                    fontSize: 26,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -1,
                  ),
                ),
                IconButton(
                  icon: const Icon(
                    Icons.refresh,
                    color: Color(0xFFFFB03B),
                  ),
                  onPressed: _loadCollection,
                ),
              ],
            ),

            const SizedBox(height: 4),

            Text(
              '${collection.length} cartas descubiertas',
              style: const TextStyle(
                color: Color.fromRGBO(255, 250, 243, 0.6),
                fontSize: 13,
              ),
            ),

            const SizedBox(height: 14),

            Expanded(
              child: isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFFEA7424),
                      ),
                    )
                  : ListView(
                      padding: const EdgeInsets.only(bottom: 24),
                      children: [
                        if (collection.isEmpty)
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 35,
                            ),
                            child: Column(
                              children: [
                                Icon(
                                  Icons.style_outlined,
                                  size: 64,
                                  color: Colors.white.withOpacity(0.2),
                                ),
                                const SizedBox(height: 12),
                                const Text(
                                  'Aún no tienes cartas en tu colección.\n¡Usa el escáner para descubrir y añadir cartas!',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white54,
                                    fontSize: 13,
                                    height: 1.4,
                                  ),
                                ),
                              ],
                            ),
                          )
                        else
                          GridView.builder(
                            shrinkWrap: true,
                            physics:
                                const NeverScrollableScrollPhysics(),
                            itemCount: collection.length,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 14,
                              mainAxisSpacing: 14,
                              childAspectRatio: 0.70,
                            ),
                            itemBuilder: (context, index) {
                              final card = collection[index];
                              final bool isTcgdex =
                                  card is TcgdexCard;

                              final colors = isTcgdex
                                  ? _getElementColors('normal')
                                  : _getElementColors(
                                      card.elementType,
                                    );

                              final icon = isTcgdex
                                  ? Icons.style
                                  : _getElementIcon(
                                      card.elementType,
                                    );

                              final String priceText = isTcgdex
                                  ? 'Por calcular'
                                  : '\$${card.price.toStringAsFixed(0)}';

                              final String imageUrl = card.imageUrl;

                              return GestureDetector(
                                onTap: () => _showCardDetails(card),
                                child: Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: colors,
                                  ),
                                  borderRadius:
                                      BorderRadius.circular(20),
                                  border: Border.all(
                                    color: Colors.white.withOpacity(0.12),
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            padding:
                                                const EdgeInsets.symmetric(
                                              horizontal: 8,
                                              vertical: 3,
                                            ),
                                            decoration: BoxDecoration(
                                              color: Colors.black
                                                  .withOpacity(0.3),
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            child: Text(
                                              priceText,
                                              style: const TextStyle(
                                                color: Color(0xFFFFD17A),
                                                fontSize: 11,
                                                fontWeight:
                                                    FontWeight.w800,
                                              ),
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () =>
                                                _confirmDeleteCard(card),
                                            child: Icon(
                                              Icons.delete_outline,
                                              color: Colors.white
                                                  .withOpacity(0.8),
                                              size: 18,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const Spacer(),
                                      Expanded(
                                        flex: 4,
                                        child: Center(
                                          child: imageUrl.isNotEmpty
                                              ? Image.network(
                                                  imageUrl,
                                                  fit: BoxFit.contain,
                                                  errorBuilder: (
                                                    context,
                                                    error,
                                                    stackTrace,
                                                  ) {
                                                    return Icon(
                                                      icon,
                                                      size: 52,
                                                      color: Colors.white,
                                                    );
                                                  },
                                                )
                                              : Icon(
                                                  icon,
                                                  size: 52,
                                                  color: Colors.white,
                                                ),
                                        ),
                                      ),
                                      const Spacer(),
                                      Text(
                                        card.category.toUpperCase(),
                                        style: TextStyle(
                                          color: Colors.white
                                              .withOpacity(0.7),
                                          fontSize: 9,
                                          fontWeight: FontWeight.w700,
                                          letterSpacing: 1,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        card.name,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 13,
                                          height: 1.1,
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                ),
                              );
                            },
                          ),

                        const SizedBox(height: 28),

                        const Text(
                          'Cartas deseadas',
                          style: TextStyle(
                            color: Color(0xFFFFFAF3),
                            fontSize: 26,
                            fontWeight: FontWeight.w900,
                            letterSpacing: -1,
                          ),
                        ),

                        const SizedBox(height: 4),

                        Text(
                          '${wishlist.length} cartas que deseas conseguir',
                          style: const TextStyle(
                            color: Color.fromRGBO(255, 250, 243, 0.6),
                            fontSize: 13,
                          ),
                        ),

                        const SizedBox(height: 14),

                        if (wishlist.isEmpty)
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 25,
                            ),
                            child: Column(
                              children: [
                                Icon(
                                  Icons.favorite_border,
                                  size: 54,
                                  color: Colors.white.withOpacity(0.2),
                                ),
                                const SizedBox(height: 12),
                                const Text(
                                  'Todavía no tienes cartas deseadas.\n¡Explora la Lupa y guarda las cartas que quieres conseguir!',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white54,
                                    fontSize: 13,
                                    height: 1.4,
                                  ),
                                ),
                              ],
                            ),
                          )
                        else
                          GridView.builder(
                            shrinkWrap: true,
                            physics:
                                const NeverScrollableScrollPhysics(),
                            itemCount: wishlist.length,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 14,
                              mainAxisSpacing: 14,
                              childAspectRatio: 0.70,
                            ),
                            itemBuilder: (context, index) {
                              return _buildWishlistCard(
                                wishlist[index],
                              );
                            },
                          ),
                      ],
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
class ScannerScreen extends StatefulWidget {
  const ScannerScreen({super.key});

  @override
  State<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen> {
  bool isScanning = false;
  final ImagePicker _picker = ImagePicker();


  Future<void> realScan(BuildContext context) async {
    try {
      // Abrir la cámara y tomar la fotografía.
      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 90,
      );

      if (image == null) return;

      if (!mounted) return;
      setState(() => isScanning = true);

      // Enviar la fotografía a Gemini.
      final result = await ApiService.scanPokemonCard(image.path);

      // Obtener las coincidencias encontradas en TCGdex.
      final rawCandidates = result['candidates'];

      final List<Map<String, dynamic>> candidates =
          rawCandidates is List
              ? rawCandidates
                  .whereType<Map>()
                  .map((item) => Map<String, dynamic>.from(item))
                  .toList()
              : [];

      if (!mounted) return;

      if (candidates.isEmpty) {
        final identified = result['identified'];
        final pokemonName = identified is Map
            ? identified['pokemon_name']?.toString() ?? 'Carta Pokémon'
            : 'Carta Pokémon';

        await showDialog(
          context: context,
          builder: (dialogContext) => AlertDialog(
            backgroundColor: const Color(0xFF21120E),
            title: const Text(
              'No encontramos coincidencias',
              style: TextStyle(color: Color(0xFFFFFAF3)),
            ),
            content: Text(
              'La IA identificó: $pokemonName.\n\n'
              'Pero no encontramos una carta coincidente en TCGdex. '
              'Intenta tomar otra fotografía con buena iluminación.',
              style: const TextStyle(color: Colors.white70),
            ),
            actions: [
              FilledButton(
                onPressed: () => Navigator.pop(dialogContext),
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFFEA7424),
                ),
                child: const Text('Aceptar'),
              ),
            ],
          ),
        );

        return;
      }

      // Mostrar las cartas encontradas para que el usuario elija.
      await showDialog(
        context: context,
        builder: (dialogContext) {
          return AlertDialog(
            backgroundColor: const Color(0xFF21120E),
            title: const Row(
              children: [
                Icon(
                  Icons.auto_awesome,
                  color: Color(0xFFFFB03B),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    '¡Carta reconocida!',
                    style: TextStyle(
                      color: Color(0xFFFFFAF3),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            content: SizedBox(
              width: double.maxFinite,
              height: 400,
              child: ListView.separated(
                itemCount: candidates.length,
                separatorBuilder: (_, __) => const Divider(
                  color: Colors.white24,
                ),
                itemBuilder: (itemContext, index) {
                  final candidate = candidates[index];

                  final name =
                      candidate['name']?.toString() ?? 'Carta Pokémon';

                  final imageBase =
                      candidate['image']?.toString() ?? '';

                  final imageUrl = imageBase.isEmpty
                      ? ''
                      : '$imageBase/high.png';

                  final rarity =
                      candidate['rarity']?.toString() ?? 'Sin rareza';

                  final setName =
                      candidate['set_name']?.toString() ?? '';

                  final cardNumber =
                      candidate['local_id']?.toString() ?? '';

                  final hp = candidate['hp']?.toString();

                  final price = double.tryParse(
                    candidate['price_dop']?.toString() ?? '',
                  );

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (imageUrl.isNotEmpty)
  GestureDetector(
    onTap: () {
      showDialog(
        context: dialogContext,
        builder: (zoomContext) {
          return Dialog(
            backgroundColor: const Color(0xFF21120E),
            child: Stack(
              alignment: Alignment.topRight,
              children: [
                InteractiveViewer(
                  minScale: 1,
                  maxScale: 5,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Image.network(
                      imageUrl,
                      fit: BoxFit.contain,
                      errorBuilder: (_, __, ___) =>
                          const Icon(
                        Icons.image_not_supported,
                        color: Colors.white54,
                        size: 80,
                      ),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(zoomContext),
                  icon: const Icon(
                    Icons.close,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          );
        },
      );
    },
    child: ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Image.network(
        imageUrl,
        width: 85,
        height: 115,
        fit: BoxFit.contain,
        errorBuilder: (_, __, ___) => const SizedBox(
          width: 85,
          height: 115,
          child: Icon(
            Icons.image_not_supported,
            color: Colors.white54,
          ),
        ),
      ),
    ),
  ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                Text(
                                  name,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  'Rareza: $rarity',
                                  style: const TextStyle(
                                    color: Color(0xFFFFC564),
                                  ),
                                ),
                                if (setName.isNotEmpty)
                                  Text(
                                    'Colección: $setName',
                                    style: const TextStyle(
                                      color: Colors.white70,
                                      fontSize: 12,
                                    ),
                                  ),
                                if (cardNumber.isNotEmpty)
                                  Text(
                                    'Número: $cardNumber',
                                    style: const TextStyle(
                                      color: Colors.white70,
                                      fontSize: 12,
                                    ),
                                  ),
                                if (hp != null && hp != 'null')
                                  Text(
                                    'HP: $hp',
                                    style: const TextStyle(
                                      color: Colors.white70,
                                      fontSize: 12,
                                    ),
                                  ),
                                const SizedBox(height: 5),
                                Text(
                                  price != null
                                      ? 'Valor: RD\$ ${price.toStringAsFixed(2)}'
                                      : 'Valor: No disponible',
                                  style: const TextStyle(
                                    color: Colors.greenAccent,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton.icon(
                          onPressed: () async {
                            try {
                              final cardId =
                                  candidate['id']?.toString() ?? '';

                              if (cardId.isEmpty) {
                                throw Exception(
                                  'No se encontró el identificador de la carta',
                                );
                              }

                              final message =
                                  await ApiService
                                      .addTcgdexCardToCollection(cardId);

                              if (!mounted ||
                                  !dialogContext.mounted) {
                                return;
                              }

                              Navigator.pop(dialogContext);

                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(message),
                                  backgroundColor: Colors.green,
                                ),
                              );
                            } catch (e) {
                              if (!dialogContext.mounted) return;

                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(e.toString()),
                                  backgroundColor: Colors.redAccent,
                                ),
                              );
                            }
                          },
                          icon: const Icon(Icons.add),
                          label: const Text('Agregar a mi colección'),
                          style: FilledButton.styleFrom(
                            backgroundColor: const Color(0xFFEA7424),
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext),
                child: const Text(
                  'Cerrar',
                  style: TextStyle(color: Color(0xFFFFC564)),
                ),
              ),
            ],
          );
        },
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
          backgroundColor: Colors.redAccent,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => isScanning = false);
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
          child: Column(
            children: [
              AppHeader(),
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
              const SizedBox(height: 28),

              if (isScanning) ...[
                const Column(
                  children: [
                    SizedBox(
                      width: 38,
                      height: 38,
                      child: CircularProgressIndicator(
                        strokeWidth: 3,
                        color: Color(0xFFFFA33B),
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      '⚡ ¡Estamos descubriendo tu Pokémon!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xFFFFB13B),
                        fontSize: 17,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      'La IA está analizando tu carta...',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color.fromRGBO(255, 250, 243, 0.65),
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
              ],

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

              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                height: 52,
                child: FilledButton.icon(
                  onPressed: isScanning ? null : () => realScan(context),
                  icon: const Icon(Icons.camera_alt),
                  label: const Text(
                    'Escanear (Cámara)',
                    style: TextStyle(fontWeight: FontWeight.w800),
                  ),
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFFEA7424),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
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
// 6. PANTALLA DE LUPA / BÚSQUEDA EXCLUSIVA
// ====================================================================

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController searchController = TextEditingController();
  Timer? _debounce;
  List<TcgdexCard> searchResults = [];
  List<String> categories = ['Todas', 'Legendaria', 'Épica', 'Rara', 'Especial'];
  String selectedCategory = 'Todas';
  bool isLoading = false;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _performSearch();
    _fetchCategories();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    searchController.dispose();
    super.dispose();
  }

  Future<void> _fetchCategories() async {
    try {
      final fetched = await ApiService.getCategories();
      if (mounted && fetched.isNotEmpty) {
        setState(() {
          categories = ['Todas', ...fetched.where((c) => c != 'Todas')];
        });
      }
    } catch (_) {}
  }

  Future<void> _performSearch() async {
    final query = searchController.text.trim();

    if (query.isEmpty) {
      setState(() {
        searchResults = [];
        errorMessage = null;
        isLoading = false;
      });
      return;
    }

    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final results = await ApiService.searchTcgdexCards(query);

      if (mounted) {
        setState(() {
          searchResults = results;
          isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          errorMessage = 'Error al conectar con TCGdex.';
          isLoading = false;
        });
      }
    }
  }

  IconData _getElementIcon(String elementType) {
    switch (elementType.toLowerCase()) {
      case 'fuego':
        return Icons.local_fire_department;
      case 'agua':
        return Icons.water_drop;
      case 'planta':
        return Icons.forest;
      case 'electrico':
        return Icons.bolt;
      case 'psiquico':
        return Icons.auto_awesome;
      default:
        return Icons.style;
    }
  }

  List<Color> _getElementColors(String elementType) {
    switch (elementType.toLowerCase()) {
      case 'fuego':
        return const [Color(0xFFEA7022), Color(0xFF8A250F)];
      case 'agua':
        return const [Color(0xFF1685B8), Color(0xFF0B3A70)];
      case 'planta':
        return const [Color(0xFF3E9B4F), Color(0xFF174C2C)];
      case 'electrico':
        return const [Color(0xFFF4B82D), Color(0xFF9B5515)];
      case 'psiquico':
        return const [Color(0xFF7759B8), Color(0xFF281848)];
      default:
        return const [Color(0xFFDD59A4), Color(0xFF712A67)];
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppHeader(),
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
  controller: searchController,
  onChanged: (_) {
    _debounce?.cancel();
    _debounce = Timer(
      const Duration(milliseconds: 500),
      _performSearch,
    );
  },
  style: const TextStyle(color: Colors.white),
  cursorColor: const Color(0xFFFFB13B),
  keyboardAppearance: Brightness.dark,
  decoration: InputDecoration(
    hintText: 'Buscar cartas...',
    hintStyle: TextStyle(color: Colors.white.withOpacity(0.3)),
    prefixIcon: const Icon(
      Icons.search,
      color: Color(0xFFFFB13B),
    ),
    suffixIcon: searchController.text.isNotEmpty
        ? IconButton(
            icon: const Icon(Icons.clear, color: Colors.white54),
            onPressed: () {
              searchController.clear();
              setState(() {});
              _performSearch();
            },
          )
        : null,
    filled: true,
    fillColor: const Color(0xFF21120E),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(18),
      borderSide: BorderSide.none,
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(18),
      borderSide: BorderSide.none,
    ),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(18),
      borderSide: BorderSide.none,
    ),
  ),
),
            const SizedBox(height: 14),
            SizedBox(
              height: 38,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: categories.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final cat = categories[index];
                  final isSelected = selectedCategory == cat;
                  return ChoiceChip(
                    label: Text(cat),
                    selected: isSelected,
                    selectedColor: const Color(0xFFEA7424),
                    backgroundColor: const Color(0xFF21120E),
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : Colors.white70,
                      fontWeight: isSelected
                          ? FontWeight.bold
                          : FontWeight.normal,
                      fontSize: 12,
                    ),
                    onSelected: (selected) {
                      if (selected) {
                        setState(() {
                          selectedCategory = cat;
                        });
                        _performSearch();
                      }
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 18),
            Expanded(
              child: isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFFEA7424),
                      ),
                    )
                  : errorMessage != null
                      ? Center(
                          child: Text(
                            errorMessage!,
                            style: const TextStyle(color: Colors.redAccent),
                          ),
                        )
                      : searchResults.isEmpty
    ? Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                searchController.text.trim().isEmpty
                    ? Icons.auto_awesome
                    : Icons.search_off,
                size: 76,
                color: const Color(0xFFEA7424),
              ),
              const SizedBox(height: 20),
              Text(
                searchController.text.trim().isEmpty
                    ? '¡Tu próxima carta te espera!'
                    : 'No encontramos esa carta',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Color(0xFFFFB13B),
                  fontSize: 21,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                searchController.text.trim().isEmpty
                    ? 'Explora el universo Pokémon y descubre nuevas cartas para tu colección.'
                    : 'Intenta con otro nombre o explora las categorías.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.6),
                  fontSize: 14,
                  height: 1.6,
                ),
              ),
            ],
          ),
        ),
      )
                          : GridView.builder(
                              itemCount: searchResults.length,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 14,
                                mainAxisSpacing: 14,
                                childAspectRatio: 0.70,
                              ),
                              itemBuilder: (context, index) {
                                final card = searchResults[index];
                                final colors =
                                    _getElementColors(card.category);

                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            CardDetailScreen(card: card),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                        colors: colors,
                                      ),
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(
                                        color: Colors.white.withOpacity(0.12),
                                      ),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(12),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 8,
                                              vertical: 3,
                                            ),
                                            decoration: BoxDecoration(
                                              color:
                                                  Colors.black.withOpacity(0.3),
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            child: Text(
                                              card.rarity,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                color: Color(0xFFFFD17A),
                                                fontSize: 10,
                                                fontWeight: FontWeight.w800,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          Expanded(
                                            child: Center(
                                              child: card.imageUrl.isNotEmpty
                                                  ? Image.network(
                                                      card.imageUrl,
                                                      fit: BoxFit.contain,
                                                      errorBuilder:
                                                          (_, __, ___) {
                                                        return const Icon(
                                                          Icons
                                                              .image_not_supported,
                                                          color: Colors.white54,
                                                          size: 45,
                                                        );
                                                      },
                                                    )
                                                  : const Icon(
                                                      Icons.image_not_supported,
                                                      color: Colors.white54,
                                                      size: 45,
                                                    ),
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            card.category.toUpperCase(),
                                            style: TextStyle(
                                              color: Colors.white
                                                  .withOpacity(0.7),
                                              fontSize: 9,
                                              fontWeight: FontWeight.w700,
                                              letterSpacing: 1,
                                            ),
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            card.name,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 13,
                                              height: 1.1,
                                              fontWeight: FontWeight.w800,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
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



// ====================================================================
// 7. PANTALLA DE IA INDEPENDIENTE (IA BOT)
// ====================================================================
class AIAssistantScreen extends StatefulWidget {
  const AIAssistantScreen({super.key});

  @override
  State<AIAssistantScreen> createState() => _AIAssistantScreenState();
}

class _AIAssistantScreenState extends State<AIAssistantScreen> {
  final TextEditingController messageController = TextEditingController();
  final ScrollController scrollController = ScrollController();

  final List<_ChatMessage> messages = [
    _ChatMessage(
      text:
          'Hola Coleccionista. ¿En me te puedo ayudar hoy? Puedo analizar el valor estimado de tu Charizard o sugerirte nuevas cartas.',
      isUser: false,
    ),
  ];

  bool isLoading = false;

  @override
  void dispose() {
    messageController.dispose();
    scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _sendMessage() async {
    final text = messageController.text.trim();
    if (text.isEmpty || isLoading) return;

    setState(() {
      messages.add(_ChatMessage(text: text, isUser: true));
      isLoading = true;
    });

    messageController.clear();
    _scrollToBottom();

    try {
      final reply = await ApiService.askAI(text);
      if (mounted) {
        setState(() {
          messages.add(_ChatMessage(text: reply, isUser: false));
          isLoading = false;
        });
        _scrollToBottom();
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          messages.add(_ChatMessage(
            text: '⚠️ No se pudo conectar con el servidor de IA. Verifica tu conexión.',
            isUser: false,
          ));
          isLoading = false;
        });
        _scrollToBottom();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppHeader(),
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
            Expanded(
              child: ListView.builder(
                controller: scrollController,
                itemCount: messages.length + (isLoading ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index == messages.length && isLoading) {
                    return Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: const Color(0xFF21120E),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.white.withOpacity(0.08)),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                color: Color(0xFFFFB03B),
                                strokeWidth: 2,
                              ),
                            ),
                            SizedBox(width: 10),
                            Text(
                              'El asistente está pensando...',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  final msg = messages[index];
                  return Align(
                    alignment:
                        msg.isUser ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      padding: const EdgeInsets.all(16),
                      constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 0.82,
                      ),
                      decoration: BoxDecoration(
                        color: msg.isUser
                            ? const Color(0xFFEA7424)
                            : const Color(0xFF21120E),
                        borderRadius: BorderRadius.circular(18).copyWith(
                          bottomRight: msg.isUser
                              ? const Radius.circular(0)
                              : const Radius.circular(18),
                          bottomLeft: !msg.isUser
                              ? const Radius.circular(0)
                              : const Radius.circular(18),
                        ),
                        border: msg.isUser
                            ? null
                            : Border.all(color: Colors.white.withOpacity(0.08)),
                      ),
                      child: Text(
                        msg.text,
                        style: const TextStyle(
                          color: Color(0xFFFFFAF3),
                          fontSize: 14,
                          height: 1.4,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: messageController,
                    onSubmitted: (_) => _sendMessage(),
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
                const SizedBox(width: 10),
                Container(
                  height: 52,
                  width: 52,
                  decoration: BoxDecoration(
                    color: const Color(0xFFEA7424),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: IconButton(
                    icon: isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Icon(Icons.send, color: Colors.white),
                    onPressed: isLoading ? null : _sendMessage,
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

class _ChatMessage {
  final String text;
  final bool isUser;

  _ChatMessage({
    required this.text,
    required this.isUser,
  });
}

// ====================================================================
// 8. PANTALLA DE PERFIL
// ====================================================================
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  UserModel? currentUser;
  String? userAvatarBase64;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final savedUser = await ApiService.getSavedUser();
    String? avatar;
    if (savedUser != null) {
      avatar = await ApiService.getUserAvatar(savedUser.id);
    }
    if (mounted) {
      setState(() {
        currentUser = savedUser;
        userAvatarBase64 = avatar;
        isLoading = false;
      });
    }

    try {
      final userFromApi = await ApiService.getProfile();
      final avatarFromApi = await ApiService.getUserAvatar(userFromApi.id);
      if (mounted) {
        setState(() {
          currentUser = userFromApi;
          userAvatarBase64 = avatarFromApi;
        });
      }
    } catch (_) {}
  }

  Future<void> _pickAvatarImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: source,
      maxWidth: 600,
      maxHeight: 600,
      imageQuality: 85,
    );

    if (pickedFile == null || currentUser == null) return;

    final bytes = await pickedFile.readAsBytes();
    final base64String = base64Encode(bytes);

    await ApiService.saveUserAvatar(currentUser!.id, base64String);

    if (mounted) {
      setState(() {
        userAvatarBase64 = base64String;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('¡Foto de perfil actualizada con éxito!'),
          backgroundColor: Color(0xFFEA7424),
        ),
      );
    }
  }

  void _showAvatarOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF21120E),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 12),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Cambiar Foto de Perfil',
                style: TextStyle(
                  color: Color(0xFFFFFAF3),
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              ListTile(
                leading: const Icon(Icons.camera_alt, color: Color(0xFFFFA33B)),
                title: const Text('Tomar Foto', style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.pop(context);
                  _pickAvatarImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library, color: Color(0xFFFFA33B)),
                title: const Text('Elegir de la Galería', style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.pop(context);
                  _pickAvatarImage(ImageSource.gallery);
                },
              ),
              if (userAvatarBase64 != null)
                ListTile(
                  leading: const Icon(Icons.delete_outline, color: Colors.redAccent),
                  title: const Text('Eliminar foto', style: TextStyle(color: Colors.redAccent)),
                  onTap: () async {
                    Navigator.pop(context);
                    if (currentUser != null) {
                      await ApiService.removeUserAvatar(currentUser!.id);
                      if (mounted) {
                        setState(() {
                          userAvatarBase64 = null;
                        });
                      }
                    }
                  },
                ),
              const SizedBox(height: 12),
            ],
          ),
        );
      },
    );
  }

  Future<void> _handleLogout() async {
    await ApiService.logout();
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const WelcomeScreen(),
      ),
    );
  }

  void _openNotificationsDialog() {
    bool pushNotif = true;
    bool priceAlerts = true;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: const Color(0xFF21120E),
              title: const Text('Notificaciones', style: TextStyle(color: Color(0xFFFFFAF3))),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SwitchListTile(
                    title: const Text('Notificaciones push', style: TextStyle(color: Colors.white)),
                    value: pushNotif,
                    activeColor: const Color(0xFFEA7424),
                    onChanged: (val) => setDialogState(() => pushNotif = val),
                  ),
                  SwitchListTile(
                    title: const Text('Alertas de precios de cartas', style: TextStyle(color: Colors.white)),
                    value: priceAlerts,
                    activeColor: const Color(0xFFEA7424),
                    onChanged: (val) => setDialogState(() => priceAlerts = val),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cerrar', style: TextStyle(color: Color(0xFFFFB03B))),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _openAppearanceDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            final currentTheme = appThemeNotifier.value;
            bool isDark = currentTheme.isDarkMode;
            String selectedColor = currentTheme.themeColor;

            final colorOptions = [
              {'id': 'orange', 'name': 'Naranja Fuego', 'color': const Color(0xFFEA7424)},
              {'id': 'red', 'name': 'Rojo Calor', 'color': const Color(0xFFD32F2F)},
              {'id': 'blue', 'name': 'Azul Eléctrico', 'color': const Color(0xFF1976D2)},
              {'id': 'green', 'name': 'Verde Planta', 'color': const Color(0xFF388E3C)},
              {'id': 'purple', 'name': 'Morado Psíquico', 'color': const Color(0xFF7B1FA2)},
            ];

            return AlertDialog(
              backgroundColor: const Color(0xFF21120E),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              title: const Text(
                'Apariencia y Modo Calor',
                style: TextStyle(color: Color(0xFFFFFAF3), fontWeight: FontWeight.bold),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SwitchListTile(
                    activeColor: currentTheme.primaryColor,
                    title: const Text('Modo Oscuro', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                    subtitle: Text(
                      isDark ? 'Tema oscuro activo' : 'Tema claro activo',
                      style: const TextStyle(color: Colors.white54, fontSize: 12),
                    ),
                    value: isDark,
                    onChanged: (val) {
                      setDialogState(() {
                        isDark = val;
                      });
                      final updated = currentTheme.copyWith(isDarkMode: val);
                      appThemeNotifier.value = updated;
                      ApiService.updateSettings(darkMode: val);
                    },
                  ),
                  const Divider(color: Colors.white12, height: 24),
                  const Text(
                    'Modo Calor / Color de Acento',
                    style: TextStyle(color: Color(0xFFFFC564), fontSize: 13, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: colorOptions.map((opt) {
                      final id = opt['id'] as String;
                      final name = opt['name'] as String;
                      final color = opt['color'] as Color;
                      final isSelected = selectedColor == id;

                      return GestureDetector(
                        onTap: () {
                          setDialogState(() {
                            selectedColor = id;
                          });
                          final updated = currentTheme.copyWith(themeColor: id);
                          appThemeNotifier.value = updated;
                          ApiService.updateSettings(themeColor: id);
                        },
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 38,
                              height: 38,
                              decoration: BoxDecoration(
                                color: color,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: isSelected ? Colors.white : Colors.transparent,
                                  width: 3,
                                ),
                                boxShadow: isSelected
                                    ? [
                                        BoxShadow(
                                          color: color.withOpacity(0.6),
                                          blurRadius: 8,
                                          spreadRadius: 1,
                                        )
                                      ]
                                    : null,
                                ),
                              child: isSelected
                                  ? const Icon(Icons.check, color: Colors.white, size: 20)
                                  : null,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              name.split(' ')[0],
                              style: TextStyle(
                                color: isSelected ? Colors.white : Colors.white54,
                                fontSize: 10,
                                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Aceptar', style: TextStyle(color: currentTheme.accentColor)),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _openSupportDialog() {
    final ticketController = TextEditingController();
    bool isSending = false;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: const Color(0xFF21120E),
              title: const Text('Ayuda y Soporte', style: TextStyle(color: Color(0xFFFFFAF3))),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    '¿Tienes algún problema o duda? Envíanos tu mensaje y te contactaremos.',
                    style: TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                  const SizedBox(height: 14),
                  TextField(
                    controller: ticketController,
                    maxLines: 3,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Escribe tu mensaje...',
                      hintStyle: TextStyle(color: Colors.white.withOpacity(0.3)),
                      filled: true,
                      fillColor: const Color(0xFF160B08),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancelar', style: TextStyle(color: Colors.white54)),
                ),
                FilledButton(
                  onPressed: isSending
                      ? null
                      : () async {
                          final msg = ticketController.text.trim();
                          if (msg.length < 5) return;
                          setDialogState(() => isSending = true);
                          try {
                            await ApiService.submitSupportTicket(msg);
                            if (!context.mounted) return;
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('¡Mensaje enviado con éxito!'),
                                backgroundColor: Color(0xFFEA7424),
                              ),
                            );
                          } catch (e) {
                            setDialogState(() => isSending = false);
                            if (!context.mounted) return;
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(e.toString()),
                                backgroundColor: Colors.redAccent,
                              ),
                            );
                          }
                        },
                  style: FilledButton.styleFrom(backgroundColor: const Color(0xFFEA7424)),
                  child: isSending
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                        )
                      : const Text('Enviar'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _openAboutDialog() async {
    showDialog(
      context: context,
      builder: (context) => const Center(
        child: CircularProgressIndicator(color: Color(0xFFEA7424)),
      ),
    );

    final info = await ApiService.getAppInfo();
    if (!mounted) return;
    Navigator.pop(context);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF21120E),
          title: Text(info['app_name'] ?? 'SNAP CARD', style: const TextStyle(color: Color(0xFFFFFAF3))),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Versión: ${info['version'] ?? '1.0.0+1'}', style: const TextStyle(color: Color(0xFFFFB03B), fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              Text(info['description'] ?? '', style: const TextStyle(color: Colors.white70, fontSize: 13, height: 1.4)),
              const SizedBox(height: 14),
              Text('Desarrollado por: ${info['developer'] ?? 'Ronal'}', style: const TextStyle(color: Colors.white54, fontSize: 12)),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cerrar', style: TextStyle(color: Color(0xFFFFB03B))),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 30),
        children: [
          AppHeader(),
          const SizedBox(height: 32),
          Center(
            child: Stack(
              children: [
                GestureDetector(
                  onTap: _showAvatarOptions,
                  child: Container(
                    width: 104,
                    height: 104,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFFFF9A31),
                          Color(0xFFC84217),
                        ],
                      ),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white.withOpacity(0.8),
                        width: 3,
                      ),
                      image: userAvatarBase64 != null
                          ? DecorationImage(
                              image: MemoryImage(base64Decode(userAvatarBase64!)),
                              fit: BoxFit.cover,
                            )
                          : null,
                    ),
                    child: userAvatarBase64 == null
                        ? const Icon(
                            Icons.person,
                            color: Colors.white,
                            size: 54,
                          )
                        : null,
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: GestureDetector(
                    onTap: _showAvatarOptions,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        color: Color(0xFFEA7424),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black45,
                            blurRadius: 4,
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.camera_alt,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Text(
            currentUser?.name ?? 'Coleccionista',
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Color(0xFFFFFAF3),
              fontSize: 24,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            currentUser?.email ?? 'Coleccionista de Aventuras',
            textAlign: TextAlign.center,
            style: const TextStyle(
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
          ProfileOption(
            icon: Icons.edit_outlined,
            title: 'Editar perfil',
            onTap: () async {
              final updated = await Navigator.push<UserModel>(
                context,
                MaterialPageRoute(
                  builder: (context) => EditProfileScreen(user: currentUser),
                ),
              );
              if (updated != null) {
                setState(() {
                  currentUser = updated;
                });
              }
            },
          ),
          ProfileOption(
            icon: Icons.notifications_outlined,
            title: 'Notificaciones',
            onTap: _openNotificationsDialog,
          ),
          ProfileOption(
            icon: Icons.palette_outlined,
            title: 'Apariencia',
            onTap: _openAppearanceDialog,
          ),
          ProfileOption(
            icon: Icons.help_outline,
            title: 'Ayuda y soporte',
            onTap: _openSupportDialog,
          ),
          ProfileOption(
            icon: Icons.info_outline,
            title: 'Acerca de SNAP CARD',
            onTap: _openAboutDialog,
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: OutlinedButton.icon(
              onPressed: _handleLogout,
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
  final VoidCallback? onTap;

  const ProfileOption({
    super.key,
    required this.icon,
    required this.title,
    this.onTap,
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
        onTap: onTap ?? () {},
      ),
    );
  }
}

// ====================================================================
// PANTALLA DE EDITAR PERFIL
// ====================================================================
class EditProfileScreen extends StatefulWidget {
  final UserModel? user;
  const EditProfileScreen({super.key, this.user});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late final TextEditingController nameController;
  late final TextEditingController emailController;
  String? userAvatarBase64;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.user?.name ?? '');
    emailController = TextEditingController(text: widget.user?.email ?? '');
    _loadAvatar();
  }

  Future<void> _loadAvatar() async {
    if (widget.user != null) {
      final avatar = await ApiService.getUserAvatar(widget.user!.id);
      if (mounted) {
        setState(() {
          userAvatarBase64 = avatar;
        });
      }
    }
  }

  Future<void> _pickAvatarImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: source,
      maxWidth: 600,
      maxHeight: 600,
      imageQuality: 85,
    );

    if (pickedFile == null || widget.user == null) return;

    final bytes = await pickedFile.readAsBytes();
    final base64String = base64Encode(bytes);

    await ApiService.saveUserAvatar(widget.user!.id, base64String);

    if (mounted) {
      setState(() {
        userAvatarBase64 = base64String;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('¡Foto de perfil actualizada!'),
          backgroundColor: Color(0xFFEA7424),
        ),
      );
    }
  }

  void _showAvatarOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF21120E),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 12),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Cambiar Foto de Perfil',
                style: TextStyle(
                  color: Color(0xFFFFFAF3),
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              ListTile(
                leading: const Icon(Icons.camera_alt, color: Color(0xFFFFA33B)),
                title: const Text('Tomar Foto', style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.pop(context);
                  _pickAvatarImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library, color: Color(0xFFFFA33B)),
                title: const Text('Elegir de la Galería', style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.pop(context);
                  _pickAvatarImage(ImageSource.gallery);
                },
              ),
              if (userAvatarBase64 != null)
                ListTile(
                  leading: const Icon(Icons.delete_outline, color: Colors.redAccent),
                  title: const Text('Eliminar foto', style: TextStyle(color: Colors.redAccent)),
                  onTap: () async {
                    Navigator.pop(context);
                    if (widget.user != null) {
                      await ApiService.removeUserAvatar(widget.user!.id);
                      if (mounted) {
                        setState(() {
                          userAvatarBase64 = null;
                        });
                      }
                    }
                  },
                ),
              const SizedBox(height: 12),
            ],
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    super.dispose();
  }

  Future<void> _saveProfile() async {
    final name = nameController.text.trim();
    final email = emailController.text.trim();

    if (name.isEmpty || email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor completa todos los campos'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final updatedUser = await ApiService.updateProfile(name: name, email: email);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('¡Perfil actualizado con éxito!'),
          backgroundColor: Color(0xFFEA7424),
        ),
      );
      Navigator.pop(context, updatedUser);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
          backgroundColor: Colors.redAccent,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF160B08),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Editar Perfil', style: TextStyle(color: Color(0xFFFFFAF3))),
        iconTheme: const IconThemeData(color: Color(0xFFFFFAF3)),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Stack(
                  children: [
                    GestureDetector(
                      onTap: _showAvatarOptions,
                      child: Container(
                        width: 96,
                        height: 96,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [
                              Color(0xFFFF9A31),
                              Color(0xFFC84217),
                            ],
                          ),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white.withOpacity(0.8),
                            width: 3,
                          ),
                          image: userAvatarBase64 != null
                              ? DecorationImage(
                                  image: MemoryImage(base64Decode(userAvatarBase64!)),
                                  fit: BoxFit.cover,
                                )
                              : null,
                        ),
                        child: userAvatarBase64 == null
                            ? const Icon(
                                Icons.person,
                                color: Colors.white,
                                size: 48,
                              )
                            : null,
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: _showAvatarOptions,
                        child: Container(
                          padding: const EdgeInsets.all(7),
                          decoration: const BoxDecoration(
                            color: Color(0xFFEA7424),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black45,
                                blurRadius: 4,
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.camera_alt,
                            color: Colors.white,
                            size: 16,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'ACTUALIZA TUS DATOS',
                style: TextStyle(
                  color: Color(0xFFFFC564),
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: nameController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Nombre de Coleccionista',
                  labelStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
                  filled: true,
                  fillColor: const Color(0xFF22110C),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Correo electrónico',
                  labelStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
                  filled: true,
                  fillColor: const Color(0xFF22110C),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                height: 54,
                child: FilledButton(
                  onPressed: isLoading ? null : _saveProfile,
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFFEA7424),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: isLoading
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2.5,
                          ),
                        )
                      : const Text(
                          'Guardar cambios',
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 16,
                          ),
                        ),
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
// 9. ENCABEZADO COMPARTIDO
// ====================================================================

class CardDetailScreen extends StatefulWidget {
  final TcgdexCard card;

  const CardDetailScreen({
    super.key,
    required this.card,
  });

  @override
  State<CardDetailScreen> createState() => _CardDetailScreenState();
}

class _CardDetailScreenState extends State<CardDetailScreen> {
  bool isSaving = false;

  Future<void> _addToWishlist() async {
    if (isSaving) return;

    setState(() {
      isSaving = true;
    });

    try {
      final message =
          await ApiService.addTcgdexCardToWishlist(widget.card.id);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('No se pudo guardar la carta: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          isSaving = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final card = widget.card;

    return Scaffold(
      backgroundColor: const Color(0xFF160D0A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF21120E),
        foregroundColor: Colors.white,
        title: const Text('Detalles de la carta'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
  child: card.imageUrl.isNotEmpty
      ? InteractiveViewer(
          minScale: 1,
          maxScale: 5,
          child: Image.network(
            card.imageUrl,
            height: 330,
            fit: BoxFit.contain,
            errorBuilder: (_, __, ___) => const Icon(
              Icons.image_not_supported,
              color: Colors.white54,
              size: 80,
            ),
          ),
        )
      : const Icon(
          Icons.image_not_supported,
          color: Colors.white54,
          size: 80,
        ),
),
            const SizedBox(height: 24),
            Text(
              card.name,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 27,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 12),
            _detailRow('Rareza', card.rarity),
            _detailRow('Categoría', card.category),
            _detailRow('HP', card.hp?.toString() ?? 'No disponible'),
            _detailRow(
              'Tipo',
              card.types.isEmpty ? 'No disponible' : card.types.join(', '),
            ),
            _detailRow('Expansión', card.setName),
            _detailRow('Número de carta', card.localId),
            _detailRow('Etapa', card.stage),
            _detailRow('Ilustrador', card.illustrator),
            _detailRow('ID TCGdex', card.id),

            const SizedBox(height: 28),

            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton.icon(
                onPressed: isSaving ? null : _addToWishlist,
                icon: isSaving
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.favorite_border),
                label: Text(
                  isSaving ? 'Guardando...' : 'Desear Carta',
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF6D00),
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: Colors.orange.shade900,
                  textStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
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

  Widget _detailRow(String label, String value) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.white12),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.white54,
                fontSize: 14,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              value.isEmpty ? 'No disponible' : value,
              textAlign: TextAlign.end,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

