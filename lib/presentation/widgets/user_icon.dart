import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';

import '../../domain/types/user.dart';
import '../pages/profile.dart';
import '../router/page_path.dart';

class UserIcon extends StatelessWidget {
  final String? imageUrl;
  final double size;
  final bool? isDisplayedStatus;
  final bool? isStatus;
  final bool? isOnTap;
  final User? user;

  const UserIcon({
    super.key,
    this.imageUrl,
    this.isDisplayedStatus,
    this.isStatus,
    this.isOnTap,
    this.user,
    required this.size,
  })  : assert(
          isDisplayedStatus == null ||
              isDisplayedStatus == false ||
              isStatus != null,
          'isStatus must be provided when isDisplayedStatus is true',
        ),
        assert(
          isOnTap == null || isOnTap == false || user != null,
          'user must be provided when isOnTap is true',
        );

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ((isOnTap ?? false) && user != null)
          ? () {
              context.push(
                PagePath.profile.path,
                extra: ProfilePage(user: user!),
              );
            }
          : null,
      child: Stack(
        children: [
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: imageUrl != null && imageUrl!.isNotEmpty
                    ? NetworkImage(imageUrl!)
                    : const AssetImage('assets/images/default_user_icon.png')
                        as ImageProvider,
                fit: BoxFit.cover,
              ),
            ),
          ),
          if (isDisplayedStatus ?? false)
            Positioned(
              right: 0,
              bottom: 0,
              child: Container(
                width: size * 0.3,
                height: size * 0.3,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: (isStatus ?? false) ? Colors.green : Colors.grey,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
