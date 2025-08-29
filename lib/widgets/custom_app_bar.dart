import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

enum CustomAppBarVariant { standard, search, profile, back }

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final CustomAppBarVariant variant;
  final List<Widget>? actions;
  final VoidCallback? onSearchTap;
  final bool showBackButton;

  const CustomAppBar({
    super.key,
    this.title,
    this.variant = CustomAppBarVariant.standard,
    this.actions,
    this.onSearchTap,
    this.showBackButton = false,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    switch (variant) {
      case CustomAppBarVariant.search:
        return _buildSearchAppBar(context);
      case CustomAppBarVariant.profile:
        return _buildProfileAppBar(context);
      case CustomAppBarVariant.back:
        return _buildBackAppBar(context);
      default:
        return _buildStandardAppBar(context);
    }
  }

  AppBar _buildStandardAppBar(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: showBackButton,
      leading: showBackButton ? const BackButton() : null,
      title: title != null
          ? Text(
              title!,
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                fontSize: 20,
              ),
            )
          : null,
      actions: actions,
      centerTitle: true,
    );
  }

  AppBar _buildSearchAppBar(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: showBackButton,
      leading: showBackButton ? const BackButton() : null,
      title: Container(
        width: double.infinity,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: TextField(
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.search),
              hintText: 'Search products...',
              border: InputBorder.none,
              contentPadding: const EdgeInsets.only(bottom: 10),
              hintStyle: GoogleFonts.poppins(),
            ),
            onTap: onSearchTap,
          ),
        ),
      ),
      actions: actions,
    );
  }

  AppBar _buildProfileAppBar(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: showBackButton,
      leading: showBackButton ? const BackButton() : null,
      title: title != null
          ? Text(
              title!,
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                fontSize: 20,
              ),
            )
          : null,
      actions: actions,
    );
  }

  AppBar _buildBackAppBar(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => Navigator.of(context).pop(),
      ),
      title: title != null
          ? Text(
              title!,
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                fontSize: 20,
              ),
            )
          : null,
      actions: actions,
    );
  }
}
