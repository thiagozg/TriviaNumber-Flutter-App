import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trivia_number/features/main/presentation/bloc/bloc.dart';

class TriviaControls extends StatefulWidget {
  const TriviaControls({
    Key key,
  }) : super(key: key);

  @override
  _TriviaControlsState createState() => _TriviaControlsState();
}

class _TriviaControlsState extends State<TriviaControls> {
  final controller = TextEditingController();
  String inputText;

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
            border: OutlineInputBorder(), hintText: 'Input a number'),
        onChanged: (value) {
          inputText = value;
        },
        onSubmitted: (_) => _fetchConcreteTriviaNumber(),
      ),
      SizedBox(height: 10),
      Row(children: <Widget>[
        Expanded(
            child: RaisedButton(
                child: Text('Search'),
                color: Theme.of(context).accentColor,
                textTheme: ButtonTextTheme.primary,
                onPressed: () => _fetchConcreteTriviaNumber())),
        SizedBox(width: 10),
        Expanded(
            child: RaisedButton(
                child: Text('Get random trivia'),
                onPressed: () => _fetchRandomTriviaNumber()))
      ])
    ]);
  }

  void _fetchConcreteTriviaNumber() {
    controller.clear();
    BlocProvider.of<NumberTriviaBloc>(context)
        .dispatch(GetTriviaForConcreteNumberEvent(inputText));
  }

  void _fetchRandomTriviaNumber() {
    controller.clear();
    BlocProvider.of<NumberTriviaBloc>(context)
        .dispatch(GetTriviaForRandomNumberEvent());
  }
}
