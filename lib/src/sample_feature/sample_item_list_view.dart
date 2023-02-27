import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:realm/realm.dart';

import '../settings/settings_view.dart';
import 'sample_item.dart';
import 'sample_item_details_view.dart';

class ListBloc {
  final RealmResults<SampleItem> items;
  final Realm _realm;
  ListBloc(this.items) : _realm = items.realm;

  void addNewItem() {
    _realm.write(() =>
        _realm.add(SampleItem(ObjectId(), 1 + (items.lastOrNull?.no ?? 0))));
  }
}

class SampleItemListView extends StatefulWidget {
  const SampleItemListView({super.key, required this.bloc});
  final ListBloc bloc;
  static const routeName = '/';

  @override
  State<SampleItemListView> createState() => _SampleItemListViewState();
}

class _SampleItemListViewState extends State<SampleItemListView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sample Items'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.restorablePushNamed(context, SettingsView.routeName);
            },
          ),
        ],
      ),
      body: StreamBuilder<Object>(
          stream: widget.bloc.items.changes,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            return ListView.builder(
              restorationId: 'sampleItemListView',
              itemCount: widget.bloc.items.length,
              itemBuilder: (BuildContext context, int index) {
                final item = widget.bloc.items[index];
                return SampleItemWidget(bloc: ItemBloc(item));
              },
            );
          }),
      floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () {
            widget.bloc.addNewItem();
          }),
    );
  }
}

class ItemBloc {
  final SampleItem item;
  final Realm _realm;
  ItemBloc(this.item) : _realm = item.realm;

  void delete() {
    _realm.write(() => _realm.delete(item));
  }
}

class SampleItemWidget extends StatelessWidget {
  const SampleItemWidget({Key? key, required this.bloc}) : super(key: key);

  final ItemBloc bloc;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(bloc.item.no),
      background: Container(color: Colors.red),
      onDismissed: ((direction) => bloc.delete()),
      child: ListTile(
          title: Text('SampleItem ${bloc.item.no}'),
          leading: const CircleAvatar(
            foregroundImage: AssetImage('assets/images/flutter_logo.png'),
          ),
          onTap: () {
            Navigator.restorablePushNamed(
              context,
              SampleItemDetailsView.routeName,
            );
          }),
    );
  }
}
