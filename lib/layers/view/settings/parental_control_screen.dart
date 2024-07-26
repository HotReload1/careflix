import 'package:careflix/core/configuration/styles.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../../generated/l10n.dart';

class ParentalControlScreen extends StatelessWidget {
  const ParentalControlScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          S.of(context).parentalControl,
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                S.of(context).qrCodeRequest,
                style: TextStyle(
                  fontSize: 20,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            QrImageView(
              data: FirebaseAuth.instance.currentUser!.uid,
              version: QrVersions.auto,
              size: 350.0,
              foregroundColor: Styles.colorPrimary,
            ),
          ],
        ),
      ),
    );
  }
}
