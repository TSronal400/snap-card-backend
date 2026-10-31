import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'models/user.dart';
import 'models/card_item.dart';
import 'services/api_service.dart';

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
  List<CardItem> collection = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCollection();
  }

  Future<void> _loadCollection() async {
    setState(() => isLoading = true);
    try {
      final items = await ApiService.getUserCollection();
      if (mounted) {
        setState(() {
          collection = items;
          isLoading = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => isLoading = false);
    }
  }

  double get totalPrice => collection.fold(0, (sum, c) => sum + c.price);

  void _confirmDeleteCard(CardItem card) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF21120E),
          title: const Text('Eliminar Carta', style: TextStyle(color: Color(0xFFFFFAF3))),
          content: Text(
            '¿Estás seguro de que deseas eliminar "${card.name}" de tu colección?',
            style: const TextStyle(color: Colors.white70),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar', style: TextStyle(color: Colors.white54)),
            ),
            FilledButton(
              onPressed: () async {
                Navigator.pop(context);
                try {
                  await ApiService.removeCardFromCollection(card.id);
                  _loadCollection();
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
              style: FilledButton.styleFrom(backgroundColor: Colors.redAccent),
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
                  icon: const Icon(Icons.refresh, color: Color(0xFFFFB03B)),
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
                  ? const Center(child: CircularProgressIndicator(color: Color(0xFFEA7424)))
                  : collection.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.style_outlined, size: 64, color: Colors.white.withOpacity(0.2)),
                              const SizedBox(height: 12),
                              const Text(
                                'Aún no tienes cartas en tu colección.\n¡Usa el escáner para descubrir y añadir cartas!',
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.white54, fontSize: 13, height: 1.4),
                              ),
                            ],
                          ),
                        )
                      : GridView.builder(
                          itemCount: collection.length,
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 14,
                            mainAxisSpacing: 14,
                            childAspectRatio: 0.70,
                          ),
                          itemBuilder: (context, index) {
                            final card = collection[index];
                            final colors = _getElementColors(card.elementType);
                            final icon = _getElementIcon(card.elementType);

                            return Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: colors,
                                ),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: Colors.white.withOpacity(0.12)),
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
                                        GestureDetector(
                                          onTap: () => _confirmDeleteCard(card),
                                          child: Icon(Icons.delete_outline, color: Colors.white.withOpacity(0.8), size: 18),
                                        ),
                                      ],
                                    ),
                                    const Spacer(),
                                    Center(child: Icon(icon, size: 52, color: Colors.white)),
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

  Future<void> simulateScan(BuildContext context) async {
    setState(() => isScanning = true);

    try {
      final allCards = await ApiService.searchCards(query: '');
      if (allCards.isEmpty) {
        throw Exception('No hay cartas disponibles en el sistema');
      }

      allCards.shuffle();
      final scannedCard = allCards.first;

      final message = await ApiService.addCardToCollection(scannedCard.id);

      if (!mounted) return;
      setState(() => isScanning = false);

      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: const Color(0xFF21120E),
            title: const Row(
              children: [
                Icon(Icons.auto_awesome, color: Color(0xFFFFB03B)),
                SizedBox(width: 8),
                Text('¡Carta Descubierta!', style: TextStyle(color: Color(0xFFFFFAF3))),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  scannedCard.name,
                  style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 6),
                Text(
                  'Categoría: ${scannedCard.category}',
                  style: const TextStyle(color: Color(0xFFFFC564), fontSize: 13),
                ),
                const SizedBox(height: 4),
                Text(
                  'Valor de Mercado: \$${scannedCard.price.toStringAsFixed(2)} USD',
                  style: const TextStyle(color: Colors.greenAccent, fontSize: 14, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                Text(
                  message,
                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ],
            ),
            actions: [
              FilledButton(
                onPressed: () => Navigator.pop(context),
                style: FilledButton.styleFrom(backgroundColor: const Color(0xFFEA7424)),
                child: const Text('Aceptar y Guardar'),
              ),
            ],
          );
        },
      );
    } catch (e) {
      if (!mounted) return;
      setState(() => isScanning = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  Future<void> realScan(BuildContext context) async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.camera);
      if (image == null) return;

      setState(() => isScanning = true);

      final allCards = await ApiService.searchCards(query: '');
      if (allCards.isEmpty) {
        throw Exception('No hay cartas disponibles en el sistema');
      }

      allCards.shuffle();
      final scannedCard = allCards.first;

      final message = await ApiService.addCardToCollection(scannedCard.id);

      if (!mounted) return;
      setState(() => isScanning = false);

      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: const Color(0xFF21120E),
            title: const Row(
              children: [
                Icon(Icons.auto_awesome, color: Color(0xFFFFB03B)),
                SizedBox(width: 8),
                Text('¡Carta Escaneada!', style: TextStyle(color: Color(0xFFFFFAF3))),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  scannedCard.name,
                  style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 6),
                Text(
                  'Categoría: ${scannedCard.category}',
                  style: const TextStyle(color: Color(0xFFFFC564), fontSize: 13),
                ),
                const SizedBox(height: 4),
                Text(
                  'Valor de Mercado: \$${scannedCard.price.toStringAsFixed(2)} USD',
                  style: const TextStyle(color: Colors.greenAccent, fontSize: 14, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                Text(
                  message,
                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ],
            ),
            actions: [
              FilledButton(
                onPressed: () => Navigator.pop(context),
                style: FilledButton.styleFrom(backgroundColor: const Color(0xFFEA7424)),
                child: const Text('Aceptar y Guardar'),
              ),
            ],
          );
        },
      );
    } catch (e) {
      if (!mounted) return;
      setState(() => isScanning = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
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
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: OutlinedButton.icon(
                onPressed: isScanning ? null : () => simulateScan(context),
                icon: const Icon(Icons.center_focus_strong),
                label: const Text(
                  'Simular escaneo',
                  style: TextStyle(fontWeight: FontWeight.w800),
                ),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Color(0xFFEA7424)),
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
  List<CardItem> searchResults = [];
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
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final results = await ApiService.searchCards(
        query: searchController.text.trim(),
        category: selectedCategory,
      );
      if (mounted) {
        setState(() {
          searchResults = results;
          isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          errorMessage = 'Error al conectar con la base de datos de cartas.';
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
              controller: searchController,
              onChanged: (_) => _performSearch(),
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Buscar cartas...',
                hintStyle: TextStyle(color: Colors.white.withOpacity(0.3)),
                prefixIcon: const Icon(Icons.search, color: Color(0xFFFFB13B)),
                suffixIcon: searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, color: Colors.white54),
                        onPressed: () {
                          searchController.clear();
                          _performSearch();
                        },
                      )
                    : null,
                filled: true,
                fillColor: const Color(0xFF21120E),
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
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
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
                      child: CircularProgressIndicator(color: Color(0xFFEA7424)),
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
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.search_off,
                                    size: 64,
                                    color: Colors.white.withOpacity(0.2),
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    'No se encontraron cartas en la base de datos',
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.5),
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : GridView.builder(
                              itemCount: searchResults.length,
                              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 14,
                                mainAxisSpacing: 14,
                                childAspectRatio: 0.70,
                              ),
                              itemBuilder: (context, index) {
                                final card = searchResults[index];
                                final colors = _getElementColors(card.elementType);
                                final icon = _getElementIcon(card.elementType);

                                return Container(
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
                                                  horizontal: 8, vertical: 3),
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
                                              icon,
                                              color: Colors.white.withOpacity(0.8),
                                              size: 18,
                                            ),
                                          ],
                                        ),
                                        const Spacer(),
                                        Center(
                                          child: Icon(
                                            icon,
                                            size: 52,
                                            color: Colors.white,
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
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final savedUser = await ApiService.getSavedUser();
    if (mounted) {
      setState(() {
        currentUser = savedUser;
        isLoading = false;
      });
    }

    try {
      final userFromApi = await ApiService.getProfile();
      if (mounted) {
        setState(() {
          currentUser = userFromApi;
        });
      }
    } catch (_) {}
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
        return AlertDialog(
          backgroundColor: const Color(0xFF21120E),
          title: const Text('Apariencia', style: TextStyle(color: Color(0xFFFFFAF3))),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.dark_mode, color: Color(0xFFFFB03B)),
                title: Text('Modo Oscuro (Activo)', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Aceptar', style: TextStyle(color: Color(0xFFFFB03B))),
            ),
          ],
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
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.user?.name ?? '');
    emailController = TextEditingController(text: widget.user?.email ?? '');
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
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'ACTUALIZA TUS DATOS',
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
