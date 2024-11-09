import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:habitt/services/provider/data_provider.dart';
import 'package:habitt/services/storage_service.dart';
import 'package:provider/provider.dart';

class MailService {
  get context => null;

  Future<void> sendDeletionEmail(BuildContext context) async {
    final email = Email(
      body:
          'User ID: $userId, Email: $userEmail has requested account deletion.',
      subject: 'Account Deletion Request',
      recipients: ['habitt.tracker@gmail.com'],
      isHTML: false,
    );

    try {
      await FlutterEmailSender.send(email);
      context.read<DataProvider>().updateAccountDeletionPending(true);
      print("Email prepared in user’s email client!");
    } catch (error) {
      print("Failed to send email: $error");
    }
  }

  Future<void> sendRevokeDeletionEmail(BuildContext context) async {
    final email = Email(
      body:
          'User ID: $userId, Email: $userEmail has revoked their account deletion request.',
      subject: 'Revoke Account Deletion Request',
      recipients: ['habitt.tracker@gmail.com'],
      isHTML: false,
    );

    try {
      await FlutterEmailSender.send(email);
      context.read<DataProvider>().updateAccountDeletionPending(false);
      print("Email prepared in user’s email client!");
    } catch (error) {
      print("Failed to send email: $error");
    }
  }
}
