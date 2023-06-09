import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';

extension Messages on BuildContext {
  void showError(String message, BuildContext context) {
    _showSnackbar(
      AwesomeSnackbarContent(
        title: 'Erro',
        message: message,
        contentType: ContentType.failure,
      ),
      context,
    );
  }

  void showWarning(String message, BuildContext context) {
    _showSnackbar(
      AwesomeSnackbarContent(
        title: 'Atenção',
        message: message,
        contentType: ContentType.warning,
      ),
      context,
    );
  }

  void showInfo(String message, BuildContext context) {
    _showSnackbar(
      AwesomeSnackbarContent(
        title: 'Atenção',
        message: message,
        contentType: ContentType.help,
      ),
      context,
    );
  }

  void showSuccess(String message, BuildContext context) {
    _showSnackbar(
      AwesomeSnackbarContent(
        title: 'Sucesso',
        message: message,
        contentType: ContentType.success,
      ),
      context,
    );
  }

  void _showSnackbar(AwesomeSnackbarContent content, BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        padding: const EdgeInsets.only(top: 72),
        backgroundColor: Colors.transparent,
        content: content,
      ),
    );
  }
}
