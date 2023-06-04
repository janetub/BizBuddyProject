import 'package:flutter/material.dart';

// class SearchDialog<T> extends StatefulWidget {
//   final Set<T> items;
//   final String Function(T) getName;
//   final Set<String> Function(T) getTags;
//   final Widget Function(BuildContext, T) itemBuilder;
//
//   const SearchDialog({
//     Key? key,
//     required this.items,
//     required this.getName,
//     required this.getTags,
//     required this.itemBuilder,
//   }) : super(key: key);
//
//   @override
//   _SearchDialogState createState() => _SearchDialogState();
// }
//
// class _SearchDialogState<T> extends State<SearchDialog<T>> {
//   final TextEditingController _searchController = TextEditingController();
//   Set<T> _searchResults = {};
//
//   @override
//   void initState() {
//     super.initState();
//     _searchResults = searchItems('');
//   }
//
//   Set<T> searchItems(String query) {
//     return widget.items.where((item) {
//       final nameMatch = widget.getName(item).toLowerCase().contains(query.toLowerCase());
//       final tagMatch = widget.getTags(item).any(
//               (tag) => tag.toLowerCase().contains(query.toLowerCase()));
//       return nameMatch || tagMatch;
//     }).toSet();
//   }
//
//   void _search(String query) {
//     setState(() {
//       _searchResults = searchItems(query);
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return AlertDialog(
//         backgroundColor: const Color(0xFFEEEDF1),
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(30),
//         ),
//         title: Text('Search'),
//         content: SizedBox(
//             width: double.maxFinite,
//             height: MediaQuery.of(context).size.height * 0.6,
//             child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   TextField(
//                     cursorColor: Color(0xFFEF911E),
//                     controller: _searchController,
//                     decoration: InputDecoration(
//                       labelText: 'Search',
//                       labelStyle: TextStyle(color: Colors.grey),
//                       fillColor: Colors.white,
//                       filled: true,
//                       enabledBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(15),
//                         borderSide: BorderSide(color: Colors.grey),
//                       ),
//                       focusedBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(15),
//                         borderSide: BorderSide(color: Colors.grey),
//                       ),
//                       prefixIcon: Icon(
//                         Icons.search,
//                         color: Color(0xFFEF911E),
//                       ),
//                     ),
//                     onChanged: _search,
//                   ),
//                   SizedBox(height : 20),
//                   Expanded(
//                       child : Scrollbar(isAlwaysShown : true,thickness : 3,interactive : true,
//                           child : ListView.builder(itemCount : _searchResults.length,itemBuilder :
//                               (context,index) {
//                             final item = _searchResults.elementAt(index);
//                             return widget.itemBuilder(context,item);
//                           })
//                       )
//                   )
//                 ]
//             )
//         )
//     );
//   }
// }