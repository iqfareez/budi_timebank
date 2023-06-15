import 'package:flutter/material.dart';

class DashboardLoadingText extends StatelessWidget {
  final isRequest;
  const DashboardLoadingText({super.key, this.isRequest});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          isRequest
              ? const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [Text('Total Request: '), Text('...')],
                )
              : const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [Text('Total Service: '), Text('...')],
                ),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [Text('Pending: '), Text('...')],
          ),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [Text('Accepted: '), Text('...')],
          ),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [Text('Ongoing: '), Text('...')],
          ),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [Text('Completed: '), Text('...')],
          ),
        ],
      ),
    );
  }
}
