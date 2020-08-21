import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../injection_container.dart';
import '../widgets/widgets.dart';
import '../controller/bloc.dart';

class NumberTriviaPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Number Trivia'),
      ),
      body: SingleChildScrollView(
        child: _buildBody(context),
      ),
    );
  }

  BlocProvider<NumberTriviaBloc> _buildBody(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<NumberTriviaBloc>(),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: <Widget>[
            SizedBox(height: 10),
            BlocBuilder<NumberTriviaBloc, NumberTriviaState>(
              builder: (context, state) {
                if (state is NumberTriviaInitial) {
                  return MessageDisplay(message: 'Start searching!');
                } else if (state is NumberTriviaLoading) {
                } else if (state is NumberTriviaLoaded) {
                  return TriviaDisplay(trivia: state.trivia);
                } else if (state is NumberTriviaError) {
                  return MessageDisplay(message: state.message);
                }
              },
            ),
            SizedBox(height: 20),
            TriviaControls()
          ],
        ),
      ),
    );
  }
}
