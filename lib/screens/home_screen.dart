import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../services/auth_service.dart';
import 'package:google_fonts/google_fonts.dart';
import 'new_order_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final authService = AuthService();
    final size = MediaQuery.of(context).size;
    final isAdmin = authService.isAdmin(authProvider.user?.email ?? '');

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFB1001A), // rosso scuro
        elevation: 0,
        centerTitle: true,
        title: SizedBox(
          height: 48,
          child: Image.asset(
            'assets/images/logo.png',
            fit: BoxFit.contain,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.menu, color: Colors.white),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (context) => Container(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ListTile(
                        leading: const Icon(Icons.person),
                        title: Text(
                          authProvider.user?.email ?? '',
                          style: GoogleFonts.roboto(),
                        ),
                        subtitle: Text(
                          isAdmin ? 'Amministratore' : 'Utente',
                          style: GoogleFonts.roboto(
                            color: isAdmin ? Colors.orange : Colors.grey,
                          ),
                        ),
                      ),
                      const Divider(),
                      if (isAdmin) ...[
                        ListTile(
                          leading: const Icon(Icons.admin_panel_settings),
                          title: Text(
                            'Gestione Utenti',
                            style: GoogleFonts.roboto(),
                          ),
                          onTap: () {
                            Navigator.pop(context);
                            // TODO: Navigate to user management
                          },
                        ),
                        ListTile(
                          leading: const Icon(Icons.analytics),
                          title: Text(
                            'Report e Statistiche',
                            style: GoogleFonts.roboto(),
                          ),
                          onTap: () {
                            Navigator.pop(context);
                            // TODO: Navigate to reports
                          },
                        ),
                        const Divider(),
                      ],
                      ListTile(
                        leading: const Icon(Icons.settings),
                        title: Text(
                          'Impostazioni',
                          style: GoogleFonts.roboto(),
                        ),
                        onTap: () {
                          Navigator.pop(context);
                          // TODO: Navigate to settings
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.exit_to_app),
                        title: Text(
                          'Logout',
                          style: GoogleFonts.roboto(),
                        ),
                        onTap: () async {
                          await authProvider.signOut();
                          if (context.mounted) {
                            Navigator.pop(context);
                          }
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(size.width * 0.05),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header di benvenuto personalizzato
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFB1001A), Color(0xFFD32F2F)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFB1001A).withOpacity(0.3),
                    spreadRadius: 2,
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Text(
                    'Benvenuto ${authProvider.user?.email?.split('@').first ?? ''}',
                    style: GoogleFonts.roboto(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            // Griglia pulsanti utente
            SizedBox(
              height: 400,
              child: GridView.count(
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.1,
                children: [
                  _buildUserButton(
                    context: context,
                    icon: Icons.add_shopping_cart,
                    title: 'Nuovo Ordine',
                    subtitle: 'Crea un nuovo ordine',
                    color: Colors.blue,
                    gradient: [Colors.blue.shade400, Colors.blue.shade600],
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const NewOrderScreen()),
                      );
                    },
                  ),
                  _buildUserButton(
                    context: context,
                    icon: Icons.list_alt,
                    title: 'I Miei Ordini',
                    subtitle: 'Visualizza i tuoi ordini',
                    color: Colors.green,
                    gradient: [Colors.green.shade400, Colors.green.shade600],
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('I Miei Ordini - Funzionalità in sviluppo')),
                      );
                    },
                  ),
                  _buildUserButton(
                    context: context,
                    icon: Icons.history,
                    title: 'Storico',
                    subtitle: 'Visualizza lo storico ordini',
                    color: Colors.orange,
                    gradient: [Colors.orange.shade400, Colors.orange.shade600],
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Storico - Funzionalità in sviluppo')),
                      );
                    },
                  ),
                  _buildUserButton(
                    context: context,
                    icon: Icons.notifications,
                    title: 'Notifiche',
                    subtitle: 'Gestisci le notifiche',
                    color: Colors.red,
                    gradient: [Colors.red.shade400, Colors.red.shade600],
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Notifiche - Funzionalità in sviluppo')),
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            
            // CONTENUTO PER AMMINISTRATORI
            if (isAdmin) ...[
              // Griglia scrollabile di pulsanti amministratore
              SizedBox(
                height: 500, // altezza fissa per evitare overflow
                child: GridView.count(
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1.0,
                  children: [
                    _AnimatedAdminStatButton(
                      icon: Icons.shopping_cart,
                      title: 'Ordini Totali',
                      value: '0',
                      color: Colors.blue,
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Funzionalità in sviluppo')),
                        );
                      },
                    ),
                    _AnimatedAdminStatButton(
                      icon: Icons.pending,
                      title: 'In Attesa',
                      value: '0',
                      color: Colors.orange,
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Funzionalità in sviluppo')),
                        );
                      },
                    ),
                    _AnimatedAdminStatButton(
                      icon: Icons.check_circle,
                      title: 'Completati',
                      value: '0',
                      color: Colors.green,
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Funzionalità in sviluppo')),
                        );
                      },
                    ),
                    _AnimatedAdminStatButton(
                      icon: Icons.inventory,
                      title: 'Materiali',
                      value: '0',
                      color: Colors.purple,
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Funzionalità in sviluppo')),
                        );
                      },
                    ),
                    _AnimatedAdminStatButton(
                      icon: Icons.inventory_2,
                      title: 'Gestione Materiali',
                      value: '',
                      color: Colors.orange,
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Funzionalità in sviluppo')),
                        );
                      },
                    ),
                    _AnimatedAdminStatButton(
                      icon: Icons.notifications_active,
                      title: 'Crea Notifica',
                      value: '',
                      color: Colors.red,
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Funzionalità in sviluppo')),
                        );
                      },
                    ),
                    _AnimatedAdminStatButton(
                      icon: Icons.add_box,
                      title: 'Aggiungi Materiale',
                      value: '',
                      color: Colors.teal,
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Funzionalità in sviluppo')),
                        );
                      },
                    ),
                    _AnimatedAdminStatButton(
                      icon: Icons.people,
                      title: 'Gestione Utenti',
                      value: '',
                      color: Colors.indigo,
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Funzionalità in sviluppo')),
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
            ] else ...[
              // Funzionalità Principali
              const SizedBox(height: 32),
            ],
          ],
        ),
      ),
    );
  }

  // Widget per i pulsanti utenti
  Widget _buildUserButton({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required List<Color> gradient,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: gradient,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: Colors.white, size: 48),
                const SizedBox(height: 12),
                Text(
                  title,
                  style: GoogleFonts.roboto(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: GoogleFonts.roboto(
                    fontSize: 12,
                    color: Colors.white70,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// AGGIUNTA WIDGETS PERSONALIZZATI FUORI DALLA CLASSE HOMESCREEN

class _AnimatedAdminStatButton extends StatefulWidget {
  final IconData icon;
  final String title;
  final String value;
  final Color color;
  final VoidCallback onTap;
  const _AnimatedAdminStatButton({
    required this.icon,
    required this.title,
    this.value = '',
    required this.color,
    required this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  State<_AnimatedAdminStatButton> createState() => _AnimatedAdminStatButtonState();
}

class _AnimatedAdminStatButtonState extends State<_AnimatedAdminStatButton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
      lowerBound: 0.0,
      upperBound: 0.05,
    );
    _scaleAnim = Tween<double>(begin: 1.0, end: 0.95).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    _controller.forward();
  }

  void _onTapUp(TapUpDetails details) {
    _controller.reverse();
    widget.onTap();
  }

  void _onTapCancel() {
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnim.value,
            child: child,
          );
        },
        child: Container(
          decoration: BoxDecoration(
            color: widget.color.withOpacity(0.12),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: widget.color.withOpacity(0.15),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          padding: const EdgeInsets.all(18),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(widget.icon, color: widget.color, size: 38),
              const SizedBox(height: 12),
              Text(
                widget.title,
                style: GoogleFonts.roboto(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: widget.color,
                ),
                textAlign: TextAlign.center,
              ),
              if (widget.value.isNotEmpty) ...[
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: widget.color, width: 2),
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    widget.value,
                    style: GoogleFonts.roboto(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: widget.color,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _AnimatedAdminActionButton extends StatefulWidget {
  final IconData icon;
  final String title;
  final Color color;
  final VoidCallback onTap;
  const _AnimatedAdminActionButton({
    required this.icon,
    required this.title,
    required this.color,
    required this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  State<_AnimatedAdminActionButton> createState() => _AnimatedAdminActionButtonState();
}

class _AnimatedAdminActionButtonState extends State<_AnimatedAdminActionButton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
      lowerBound: 0.0,
      upperBound: 0.05,
    );
    _scaleAnim = Tween<double>(begin: 1.0, end: 0.95).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    _controller.forward();
  }

  void _onTapUp(TapUpDetails details) {
    _controller.reverse();
    widget.onTap();
  }

  void _onTapCancel() {
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnim.value,
            child: child,
          );
        },
        child: Container(
          decoration: BoxDecoration(
            color: widget.color.withOpacity(0.12),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: widget.color.withOpacity(0.15),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          padding: const EdgeInsets.symmetric(vertical: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(widget.icon, color: widget.color, size: 32),
              const SizedBox(height: 10),
              Text(
                widget.title,
                style: GoogleFonts.roboto(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: widget.color,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
} 