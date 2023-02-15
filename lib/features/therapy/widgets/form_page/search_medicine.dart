import 'package:flutter/material.dart';
import 'package:memo_med/features/commons/widgets/widgets.dart';

class SearchMedicinePage extends StatefulWidget {
  const SearchMedicinePage({super.key});

  /// The static route for TherapyPage
  static Route<dynamic> route() {
    return MaterialPageRoute<dynamic>(builder: (_) => SearchMedicinePage());
  }

  @override
  State<SearchMedicinePage> createState() => _SearchMedicinePageState();
}

class _SearchMedicinePageState extends State<SearchMedicinePage> {
  String _searchTerm = "";
  TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    const appTitle = 'SearchMedicinePage';

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(
              color: Theme.of(context).primaryColor,
              Icons.arrow_back,
            ),
          ),
          flexibleSpace: Padding(
            padding: const EdgeInsets.fromLTRB(60.0, 8.0, 8.0, 8.0),
            child: Hero(
              tag: "searchMedicine",
              child: Material(
                child: TextInputField(
                  autoFocus: true,
                  padding: EdgeInsets.zero,
                  inputController: _controller,
                  hintText: "Visita medica",
                  labelText: "Titolo",
                ),
              ),
            ),
          ),
        ),
        body: SearchMedicineFormResult(),
      ),
    );
  }
}

// Create a Form widget.
class SearchMedicineFormResult extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Placeholder();
  }
}
