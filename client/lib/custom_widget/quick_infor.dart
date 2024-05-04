import 'package:flutter/material.dart';

class TuserQuickInfor extends StatelessWidget {
  const TuserQuickInfor({
    super.key,
    required this.currentClient,
  });

  final currentClient;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Location  ',
            style: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 18,
              color: Theme.of(context).primaryColor.withOpacity(0.4),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Expanded(
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    currentClient.address.split(',').length > 2
                        ? currentClient.address
                            .split(',')
                            .sublist(
                                currentClient.address.split(',').length - 2)
                            .join(',')
                        : currentClient.address,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                    softWrap: true,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}