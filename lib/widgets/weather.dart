import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:weather_app/widgets/widgets.dart';
import 'package:weather_app/blocs/blocs.dart';

class Weather extends StatefulWidget {
  State<Weather> createState() => _WeatherState();
}

class _WeatherState extends State<Weather> {
  late Completer<void> _refreshCompleter;
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _refreshCompleter = Completer<void>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(Icons.clear), onPressed: _searchController.clear),
        title: TextField(
          controller: _searchController,
          focusNode: _focusNode,
          style: TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: "Search City...",
            border: InputBorder.none,
            hintStyle: TextStyle(color: Colors.white),
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () async {
              if (_focusNode.hasFocus) {
                if (_searchController.text.isNotEmpty) {
                  BlocProvider.of<WeatherBloc>(context)
                      .add(WeatherRequested(city: _searchController.text));
                  FocusScope.of(context).requestFocus(new FocusNode());
                }
              } else {
                FocusScope.of(context).requestFocus(_focusNode);
              }
            },
          )
        ],
      ),
      body: Center(
        child: BlocConsumer<WeatherBloc, WeatherState>(
          listener: (context, state) {
            if (state is WeatherLoadSuccess) {
              _refreshCompleter.complete();
              _refreshCompleter = Completer();
            }
          },
          builder: (context, state) {
            if (state is WeatherInitial) {
              return Center(child: Text('Please Select a Location'));
            }
            if (state is WeatherLoadInProgress) {
              return Center(child: CircularProgressIndicator());
            }
            if (state is WeatherLoadSuccess) {
              final weather = state.weather;

              return RefreshIndicator(
                  onRefresh: () {
                    BlocProvider.of<WeatherBloc>(context).add(
                        WeatherRefreshRequested(city: state.weather.location));
                    return _refreshCompleter.future;
                  },
                  child: ListView(children: [
                    Column(children: [
                      WeatherInfo(
                        weather: weather,
                      ),
                      WeatherTable(
                        days: weather.nextDays,
                      ),
                    ])
                  ]));
            }
            if (state is WeatherLoadFailure) {
              return Text(
                'Something went wrong!',
                style: TextStyle(color: Colors.red),
              );
            }
            return Text(
              'Unknown state!',
              style: TextStyle(color: Colors.red),
            );
          },
        ),
      ),
    );
  }
}
