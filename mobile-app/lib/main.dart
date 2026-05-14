import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

const String apiBaseUrl = 'http://homeserver:8090';

void main() {
  runApp(const BoutiqueApp());
}

class BoutiqueApp extends StatelessWidget {
  const BoutiqueApp({super.key});

  @override
  Widget build(BuildContext context) {
    const seed = Color(0xFF0E7C86);
    final colorScheme = ColorScheme.fromSeed(
      seedColor: seed,
      brightness: Brightness.light,
    ).copyWith(
      secondary: const Color(0xFFE86B45),
      surface: Colors.white,
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Boutique',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: colorScheme,
        textTheme: GoogleFonts.spaceGroteskTextTheme(),
        scaffoldBackgroundColor: Colors.transparent,
        cardTheme: CardThemeData(
          color: Colors.white.withOpacity(0.92),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
      home: const HomePage(title: 'Boutique'),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final ApiService _api;
  late Future<List<Categorie>> _categoriesFuture;
  late Future<List<Produit>> _produitsFuture;
  Categorie? _selectedCategory;

  @override
  void initState() {
    super.initState();
    _api = ApiService(baseUrl: apiBaseUrl);
    _categoriesFuture = _api.fetchCategories();
    _produitsFuture = Future.value(const []);
    _categoriesFuture.then((categories) {
      if (!mounted || categories.isEmpty) {
        return;
      }
      setState(() {
        _selectedCategory = categories.first;
        _produitsFuture = _api.fetchProduits(categorieId: categories.first.id);
      });
    }).catchError((_) {});
  }

  void _reloadCategories() {
    setState(() {
      _selectedCategory = null;
      _categoriesFuture = _api.fetchCategories();
      _produitsFuture = Future.value(const []);
    });
    _categoriesFuture.then((categories) {
      if (!mounted || categories.isEmpty) {
        return;
      }
      setState(() {
        _selectedCategory = categories.first;
        _produitsFuture = _api.fetchProduits(categorieId: categories.first.id);
      });
    }).catchError((_) {});
  }

  void _onCategorySelected(Categorie? category) {
    if (category == null) {
      return;
    }
    setState(() {
      _selectedCategory = category;
      _produitsFuture = _api.fetchProduits(categorieId: category.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const _Backdrop(),
          SafeArea(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 720),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
                  child: PageReveal(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _Header(title: widget.title, onRefresh: _reloadCategories),
                        const SizedBox(height: 18),
                        _CategorySection(
                          categoriesFuture: _categoriesFuture,
                          selectedCategory: _selectedCategory,
                          onSelect: _onCategorySelected,
                          onRetry: _reloadCategories,
                        ),
                        const SizedBox(height: 16),
                        Expanded(
                          child: _ProductsSection(
                            produitsFuture: _produitsFuture,
                            selectedCategory: _selectedCategory,
                            onTap: (produit) {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => ProductDetailPage(
                                    produit: produit,
                                    api: _api,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Backdrop extends StatelessWidget {
  const _Backdrop();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFFF8F3E7),
                Color(0xFFE2F6F0),
                Color(0xFFE8EFFC),
              ],
            ),
          ),
        ),
        Positioned(
          top: -80,
          right: -40,
          child: _GlassBlob(
            diameter: 220,
            color: const Color(0xFF0E7C86).withOpacity(0.18),
          ),
        ),
        Positioned(
          bottom: -100,
          left: -40,
          child: _GlassBlob(
            diameter: 260,
            color: const Color(0xFFE86B45).withOpacity(0.16),
          ),
        ),
      ],
    );
  }
}

class _GlassBlob extends StatelessWidget {
  const _GlassBlob({required this.diameter, required this.color});

  final double diameter;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: diameter,
      height: diameter,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(diameter / 2),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.title, required this.onRefresh});

  final String title;
  final VoidCallback onRefresh;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: theme.textTheme.displaySmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF18323B),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Choose a category, browse products, then read reviews.',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: const Color(0xFF3B5460),
                ),
              ),
            ],
          ),
        ),
        IconButton(
          onPressed: onRefresh,
          icon: const Icon(Icons.refresh_rounded),
          color: const Color(0xFF0E7C86),
          tooltip: 'Reload categories',
        ),
      ],
    );
  }
}

class _CategorySection extends StatelessWidget {
  const _CategorySection({
    required this.categoriesFuture,
    required this.selectedCategory,
    required this.onSelect,
    required this.onRetry,
  });

  final Future<List<Categorie>> categoriesFuture;
  final Categorie? selectedCategory;
  final ValueChanged<Categorie?> onSelect;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Categorie>>(
      future: categoriesFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _InfoCard(
            title: 'Loading categories',
            subtitle: 'Contacting the gateway…',
            trailing: const SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(strokeWidth: 3),
            ),
          );
        }
        if (snapshot.hasError) {
          return _InfoCard(
            title: 'Categories unavailable',
            subtitle: 'Check the gateway and try again.',
            trailing: TextButton(
              onPressed: onRetry,
              child: const Text('Retry'),
            ),
          );
        }
        final categories = snapshot.data ?? const [];
        if (categories.isEmpty) {
          return const _InfoCard(
            title: 'No categories',
            subtitle: 'Seed data has not been loaded yet.',
          );
        }
        final currentSelection = categories.firstWhere(
          (category) => category.id == selectedCategory?.id,
          orElse: () => categories.first,
        );
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.9),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: const Color(0xFFDAE6E9)),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<Categorie>(
              isExpanded: true,
              value: currentSelection,
              items: categories
                  .map(
                    (category) => DropdownMenuItem<Categorie>(
                      value: category,
                      child: Text(category.nom),
                    ),
                  )
                  .toList(),
              onChanged: onSelect,
            ),
          ),
        );
      },
    );
  }
}

class _ProductsSection extends StatelessWidget {
  const _ProductsSection({
    required this.produitsFuture,
    required this.selectedCategory,
    required this.onTap,
  });

  final Future<List<Produit>> produitsFuture;
  final Categorie? selectedCategory;
  final ValueChanged<Produit> onTap;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Produit>>(
      future: produitsFuture,
      builder: (context, snapshot) {
        if (selectedCategory == null) {
          return const _EmptyState(
            title: 'Pick a category',
            subtitle: 'Products show up here once a category is selected.',
          );
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const _EmptyState(
            title: 'Loading products',
            subtitle: 'This only takes a moment.',
            showProgress: true,
          );
        }
        if (snapshot.hasError) {
          return const _EmptyState(
            title: 'Could not load products',
            subtitle: 'Check the API gateway and retry.',
          );
        }
        final produits = snapshot.data ?? const [];
        if (produits.isEmpty) {
          return const _EmptyState(
            title: 'No products found',
            subtitle: 'Try another category to continue.',
          );
        }
        return ListView.builder(
          padding: const EdgeInsets.only(bottom: 12),
          itemCount: produits.length,
          itemBuilder: (context, index) {
            final produit = produits[index];
            return StaggeredFadeIn(
              delay: Duration(milliseconds: 80 * index),
              child: ProductCard(
                produit: produit,
                onTap: () => onTap(produit),
              ),
            );
          },
        );
      },
    );
  }
}

class ProductCard extends StatelessWidget {
  const ProductCard({super.key, required this.produit, required this.onTap});

  final Produit produit;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: const LinearGradient(
              colors: [Color(0xFFFFFFFF), Color(0xFFF4F8F9)],
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF0E7C86).withOpacity(0.08),
                blurRadius: 18,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: const Color(0xFF0E7C86).withOpacity(0.15),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(
                  Icons.shopping_bag_outlined,
                  color: Color(0xFF0E7C86),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      produit.nom,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF1F2A32),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      produit.categorie.nom,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: const Color(0xFF59707B),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Text(
                          '${produit.prix.toStringAsFixed(2)} DT',
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFFE86B45),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          'Stock: ${produit.stock}',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: const Color(0xFF1F2A32),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right_rounded, color: Color(0xFF1F2A32)),
            ],
          ),
        ),
      ),
    );
  }
}

class ProductDetailPage extends StatefulWidget {
  const ProductDetailPage({super.key, required this.produit, required this.api});

  final Produit produit;
  final ApiService api;

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  late Future<List<Avis>> _avisFuture;

  @override
  void initState() {
    super.initState();
    _avisFuture = widget.api.fetchAvis(widget.produit.id);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: Stack(
        children: [
          const _Backdrop(),
          SafeArea(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 720),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: PageReveal(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            IconButton(
                              onPressed: () => Navigator.of(context).pop(),
                              icon: const Icon(Icons.arrow_back_rounded),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              widget.produit.nom,
                              style: theme.textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF18323B),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.95),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: const Color(0xFFDAE6E9)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Category: ${widget.produit.categorie.nom}',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: const Color(0xFF4B646F),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                '${widget.produit.prix.toStringAsFixed(2)} DT',
                                style: theme.textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: const Color(0xFFE86B45),
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                'Stock available: ${widget.produit.stock}',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: const Color(0xFF1F2A32),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 18),
                        Text(
                          'Reviews',
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF18323B),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Expanded(
                          child: FutureBuilder<List<Avis>>(
                            future: _avisFuture,
                            builder: (context, snapshot) {
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return const _EmptyState(
                                  title: 'Loading reviews',
                                  subtitle: 'Fetching latest feedback.',
                                  showProgress: true,
                                );
                              }
                              if (snapshot.hasError) {
                                return const _EmptyState(
                                  title: 'Reviews unavailable',
                                  subtitle: 'Could not reach the gateway.',
                                );
                              }
                              final avis = snapshot.data ?? const [];
                              if (avis.isEmpty) {
                                return const _EmptyState(
                                  title: 'No reviews yet',
                                  subtitle: 'Be the first to share feedback.',
                                );
                              }
                              return ListView.builder(
                                itemCount: avis.length,
                                itemBuilder: (context, index) {
                                  final review = avis[index];
                                  return StaggeredFadeIn(
                                    delay: Duration(milliseconds: 70 * index),
                                    child: _ReviewCard(avis: review),
                                  );
                                },
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ReviewCard extends StatelessWidget {
  const _ReviewCard({required this.avis});

  final Avis avis;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.95),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFDAE6E9)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: const Color(0xFF0E7C86).withOpacity(0.2),
                  child: Text(
                    avis.auteur.isNotEmpty ? avis.auteur[0].toUpperCase() : '?',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: const Color(0xFF0E7C86),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    avis.auteur,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF1F2A32),
                    ),
                  ),
                ),
                _StarRating(note: avis.note),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              avis.commentaire,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: const Color(0xFF4B646F),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StarRating extends StatelessWidget {
  const _StarRating({required this.note});

  final int note;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(5, (index) {
        final filled = index < note;
        return Icon(
          filled ? Icons.star_rounded : Icons.star_border_rounded,
          size: 18,
          color: filled ? const Color(0xFFE86B45) : const Color(0xFFB7C4C9),
        );
      }),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({required this.title, required this.subtitle, this.trailing});

  final String title;
  final String subtitle;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFDAE6E9)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  subtitle,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: const Color(0xFF4B646F),
                  ),
                ),
              ],
            ),
          ),
          if (trailing != null) ...[
            const SizedBox(width: 12),
            trailing!,
          ],
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({
    required this.title,
    required this.subtitle,
    this.showProgress = false,
  });

  final String title;
  final String subtitle;
  final bool showProgress;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (showProgress) ...[
            const SizedBox(
              width: 28,
              height: 28,
              child: CircularProgressIndicator(strokeWidth: 3),
            ),
            const SizedBox(height: 16),
          ],
          Text(
            title,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: const Color(0xFF18323B),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 6),
          Text(
            subtitle,
            style: theme.textTheme.bodySmall?.copyWith(
              color: const Color(0xFF4B646F),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class PageReveal extends StatefulWidget {
  const PageReveal({super.key, required this.child});

  final Widget child;

  @override
  State<PageReveal> createState() => _PageRevealState();
}

class _PageRevealState extends State<PageReveal> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _opacity;
  late final Animation<Offset> _offset;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _opacity = CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic);
    _offset = Tween<Offset>(
      begin: const Offset(0, 0.04),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _opacity,
      child: SlideTransition(position: _offset, child: widget.child),
    );
  }
}

class StaggeredFadeIn extends StatefulWidget {
  const StaggeredFadeIn({super.key, required this.child, required this.delay});

  final Widget child;
  final Duration delay;

  @override
  State<StaggeredFadeIn> createState() => _StaggeredFadeInState();
}

class _StaggeredFadeInState extends State<StaggeredFadeIn>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _opacity;
  late final Animation<Offset> _offset;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _opacity = CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic);
    _offset = Tween<Offset>(
      begin: const Offset(0, 0.06),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
    Future.delayed(widget.delay, () {
      if (mounted) {
        _controller.forward();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _opacity,
      child: SlideTransition(position: _offset, child: widget.child),
    );
  }
}

class ApiService {
  ApiService({required this.baseUrl, http.Client? client})
      : _client = client ?? http.Client();

  final String baseUrl;
  final http.Client _client;

  Future<List<Categorie>> fetchCategories() async {
    final response = await _client.get(Uri.parse('$baseUrl/api/categories'));
    if (response.statusCode != 200) {
      throw Exception('Failed to load categories');
    }
    final decoded = jsonDecode(response.body);
    if (decoded is! List) {
      throw Exception('Unexpected categories payload');
    }
    return decoded
        .map((item) => Categorie.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<List<Produit>> fetchProduits({int? categorieId}) async {
    final uri = Uri.parse('$baseUrl/api/produits').replace(
      queryParameters: categorieId == null
          ? null
          : {
              'categorieId': categorieId.toString(),
            },
    );
    final response = await _client.get(uri);
    if (response.statusCode != 200) {
      throw Exception('Failed to load products');
    }
    final decoded = jsonDecode(response.body);
    if (decoded is! List) {
      throw Exception('Unexpected products payload');
    }
    return decoded
        .map((item) => Produit.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<List<Avis>> fetchAvis(int produitId) async {
    final response = await _client.get(
      Uri.parse('$baseUrl/api/avis/$produitId'),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to load reviews');
    }
    final decoded = jsonDecode(response.body);
    if (decoded is! List) {
      throw Exception('Unexpected reviews payload');
    }
    return decoded
        .map((item) => Avis.fromJson(item as Map<String, dynamic>))
        .toList();
  }
}

class Categorie {
  const Categorie({required this.id, required this.nom});

  final int id;
  final String nom;

  factory Categorie.fromJson(Map<String, dynamic> json) {
    return Categorie(
      id: (json['id'] as num).toInt(),
      nom: json['nom'] as String,
    );
  }
}

class Produit {
  const Produit({
    required this.id,
    required this.nom,
    required this.prix,
    required this.stock,
    required this.categorie,
  });

  final int id;
  final String nom;
  final double prix;
  final int stock;
  final Categorie categorie;

  factory Produit.fromJson(Map<String, dynamic> json) {
    return Produit(
      id: (json['id'] as num).toInt(),
      nom: json['nom'] as String,
      prix: (json['prix'] as num).toDouble(),
      stock: (json['stock'] as num).toInt(),
      categorie: Categorie.fromJson(
        json['categorie'] as Map<String, dynamic>,
      ),
    );
  }
}

class Avis {
  const Avis({
    required this.id,
    required this.produitId,
    required this.auteur,
    required this.commentaire,
    required this.note,
  });

  final int id;
  final int produitId;
  final String auteur;
  final String commentaire;
  final int note;

  factory Avis.fromJson(Map<String, dynamic> json) {
    return Avis(
      id: (json['id'] as num).toInt(),
      produitId: (json['produitId'] as num).toInt(),
      auteur: json['auteur'] as String,
      commentaire: json['commentaire'] as String,
      note: (json['note'] as num).toInt(),
    );
  }
}
