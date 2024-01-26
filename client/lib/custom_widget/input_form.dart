// import 'package:flutter/material.dart';

// class IconBackground extends StatelessWidget {
//   const IconBackground({
//     Key? key,
//     required this.icon,
//     required this.onTap,
//   }) : super(key: key);

//   final IconData icon;
//   final VoidCallback onTap;

//   @override
//   Widget build(BuildContext context) {
//     return Material(
//       color: Theme.of(context).cardColor,
//       borderRadius: BorderRadius.circular(6),
//       child: InkWell(
//         borderRadius: BorderRadius.circular(6),
//         splashColor: Theme.of(context).primaryColor,
//         onTap: onTap,
//         child: Padding(
//           padding: const EdgeInsets.all(6),
//           child: Icon(
//             icon,
//             size: 22,
//           ),
//         ),
//       ),
//     );
//   }
// }

// class IconBorder extends StatelessWidget {
//   const IconBorder({
//     Key? key,
//     required this.icon,
//     required this.onTap,
//   }) : super(key: key);

//   final IconData icon;
//   final VoidCallback onTap;

//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       borderRadius: BorderRadius.circular(6),
//       splashColor: Theme.of(context).primaryColor,
//       onTap: onTap,
//       child: Container(
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(6),
//           border: Border.all(
//             width: 2,
//             color: Theme.of(context).cardColor,
//           ),
//         ),
//         child: Padding(
//           padding: const EdgeInsets.all(4),
//           child: Icon(
//             icon,
//             size: 22,
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';

// ignore: must_be_immutable
class ReusableInputField extends StatelessWidget {
  late final String labelText;
  late String hintText;
  late Function(String) onChanged;

  ReusableInputField({
    super.key,
    required this.labelText,
    required this.hintText,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        border: const OutlineInputBorder(),
      ),
      onChanged: onChanged,
    );
  }
}
