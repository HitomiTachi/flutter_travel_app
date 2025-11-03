import 'package:flutter/material.dart';
import 'package:flutter_travels_apps/core/constants/dismension_constants.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ProfileMenuItemWidget extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final Color? iconColor;
  final bool showDivider;

  const ProfileMenuItemWidget({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.iconColor,
    this.showDivider = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: kMediumPadding,
            vertical: kDefaultPadding / 2,
          ),
          leading: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: (iconColor ?? Colors.blue).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: iconColor ?? Colors.blue,
              size: 20,
            ),
          ),
          title: Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          subtitle: Text(
            subtitle,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
          trailing: const Icon(
            Icons.arrow_forward_ios,
            size: 16,
            color: Colors.grey,
          ),
          onTap: onTap,
        ),
        if (showDivider)
          Divider(
            height: 1,
            thickness: 1,
            color: Colors.grey[100],
            indent: kMediumPadding + 40 + kMediumPadding,
            endIndent: kMediumPadding,
          ),
      ],
    );
  }
}

class ProfileStatsCardWidget extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color color;

  const ProfileStatsCardWidget({
    super.key,
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(kMediumPadding),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(kTopPadding),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: color,
              size: 20,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
}

class ProfileHeaderWidget extends StatelessWidget {
  final String userName;
  final String userLocation;
  final String memberSince;
  final String avatarAsset;
  final VoidCallback onEditAvatar;

  const ProfileHeaderWidget({
    super.key,
    required this.userName,
    required this.userLocation,
    required this.memberSince,
    required this.avatarAsset,
    required this.onEditAvatar,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(kMediumPadding),
      padding: const EdgeInsets.all(kMediumPadding * 1.5),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue[400]!, Colors.blue[600]!],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(kTopPadding),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          // Avatar
          Stack(
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 4),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipOval(
                  child: Image.asset(
                    avatarAsset,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey[300],
                        child: const Icon(
                          FontAwesomeIcons.user,
                          size: 40,
                          color: Colors.grey,
                        ),
                      );
                    },
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    icon: const Icon(
                      Icons.camera_alt,
                      size: 16,
                      color: Colors.blue,
                    ),
                    onPressed: onEditAvatar,
                  ),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: kMediumPadding),
          
          // Tên và thông tin
          Text(
            userName,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          
          const SizedBox(height: 8),
          
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.location_on,
                color: Colors.white70,
                size: 16,
              ),
              const SizedBox(width: 4),
              Text(
                userLocation,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 4),
          
          Text(
            'Thành viên từ $memberSince',
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}