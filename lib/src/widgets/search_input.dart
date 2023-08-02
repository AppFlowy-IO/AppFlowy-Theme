import 'dart:async';
import 'package:appflowy_theme_marketplace/src/blocs/search_file_bloc/search_file_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/search_file_bloc/search_file_event.dart';

class SearchInput extends StatefulWidget {
  const SearchInput({super.key});

  @override
  State<SearchInput> createState() => _SearchInputState();
}

class _SearchInputState extends State<SearchInput> {
  String? _searchTerm;
  Timer? _debounceTimer;

  void _onSearchTermChanged(String value) {
    if (_debounceTimer != null && _debounceTimer!.isActive) {
      _debounceTimer!.cancel();
    }

    _debounceTimer = Timer(const Duration(milliseconds: 300), () {
      context.read<SearchFilesBloc>().add(SearchFilesRequested(value));
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 1/2,
      child: Row(
        children: [
          Expanded(
            child: TextField(
              style: const TextStyle(fontSize: 14),
              decoration: const InputDecoration(
                hintText: 'Search for plugin',
                contentPadding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 16.0),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.transparent,
                    width: 1.0,
                  ),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(5.0),
                    bottomLeft: Radius.circular(5.0),
                    topRight: Radius.zero,
                    bottomRight: Radius.zero,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.blue,
                    width: 1.0,
                  ),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(5.0),
                    bottomLeft: Radius.circular(5.0),
                    topRight: Radius.zero,
                    bottomRight: Radius.zero,
                  ),
                ),
                filled: true,
                fillColor: Colors.black12
              ),
              onChanged: (value) {
                _onSearchTermChanged(value);
                // context.read<SearchFilesBloc>().add(SearchFilesRequested(value));
              },
            ),
          ),
          ElevatedButton(
            style: ButtonStyle(
              padding: MaterialStateProperty.all(
                const EdgeInsets.symmetric(horizontal: 0, vertical: 20),
              ),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.zero,
                    bottomLeft: Radius.zero,
                    topRight: Radius.circular(5.0),
                    bottomRight: Radius.circular(5.0),
                  ),
                ),
              ),
            ),
            onPressed: () {
              // String searchUrl = '/results?search_query=${Uri.encodeComponent(_searchTerm!)}';
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //     builder: (context) => SearchResult(searchQuery: _searchTerm),
              //     settings: RouteSettings(name: searchUrl),
              //   ),
              // );
            },
            child: const Icon(Icons.search),
          ),
        ],
      ),
    );
  }
}