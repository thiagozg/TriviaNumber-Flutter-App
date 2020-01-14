import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trivia_number/features/main/presentation/bloc/bloc.dart';
import 'package:trivia_number/features/main/presentation/widgets/widgets.dart';
import 'package:trivia_number/injection_container.dart';

class NumberTriviaPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Number Trivia'),
      ),
      body: SingleChildScrollView(
          // handle open keyboard to don't let OVERFLOWING
          child: buildBody(context)
      ),
    );
  }

  BlocProvider<NumberTriviaBloc> buildBody(BuildContext context) {
    return BlocProvider(
      builder: (context) => serviceLocator<NumberTriviaBloc>(),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(children: <Widget>[
            SizedBox(height: 10),
            // Top half
            BlocBuilder<NumberTriviaBloc, NumberTriviaState>(
                builder: (context, state) => _handleBlocState(state)),
            SizedBox(height: 10),
            TriviaControls()
          ]),
        ),
      ),
    );
  }

  StatelessWidget _handleBlocState(NumberTriviaState state) {
    return state.join(
        (empty) => MessageDisplay(message: 'Start searching!'),
        (loading) => LoadingWidget(),
        (loaded) => TriviaDisplay(numberTriviaBO: loaded.triviaBO),
        (error) => MessageDisplay(message: error.message)
    );
  }
}
