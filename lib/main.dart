import 'package:bloc/bloc.dart';
import 'package:first/services/auth/auth_service.dart';
import 'package:first/constants/routes.dart';
import 'package:first/views/notes_view/create_update_note_view.dart';
import 'package:first/views/notes_view/notes_view.dart';
import 'package:first/utility_pages/auth_gate.dart';
import 'package:first/utility_pages/login_page.dart';
import 'package:first/utility_pages/signup.dart';
import 'package:first/utility_pages/verify_email.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AuthService.firebase().initialize();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // print("Main APP working");
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        loginRoute: (context) => const LoginPage(),
        signupRoute: (context) => const SignupPage(),
        notesRoute: (context) => const NotesView(),
        authGateRoute: (context) => const AuthGate(),
        verifyEmailRoute: (context) => const VerifyEmail(),
        createOrUpdateNoteRoute: (context) => const CreateUpdateNoteView(),
      },
      title: "Register app",
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final TextEditingController _textEditingController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _textEditingController = TextEditingController();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _textEditingController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      // when the provider wants bloc then run this function
      create: (context) => CounterBloc(),
      child: Scaffold(
        appBar: AppBar(title: const Text("Testing bloc")),
        body: BlocConsumer<CounterBloc, CounterState>(
          builder: (context, state) {
            final invalidValue = (state is CounterStateInvalidNumber)
                ? state.invalidValue
                : '';

            return Column(
              children: [
                Text('Current Value = ${state.value}'),
                Visibility(
                  child: Text("Invalid Value = $invalidValue"),
                  visible: state is CounterStateInvalidNumber,
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  child: TextField(
                    controller: _textEditingController,
                    decoration: InputDecoration(hintText: 'Enter number here '),
                    keyboardType: TextInputType.number,
                  ),
                ),
                SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(
                      width: 100,
                      child: FilledButton(
                        onPressed: () {
                          context.read<CounterBloc>().add(
                            IncrementEvent(_textEditingController.text),
                          );
                        },
                        child: Icon(Icons.add),
                      ),
                    ),
                    SizedBox(
                      width: 100,
                      child: FilledButton.tonal(
                        onPressed: () {
                          context.read<CounterBloc>().add(DecrementEvent(_textEditingController.text));
                        },
                        child: Icon(Icons.remove),
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
          listener: (context, state) {
            _textEditingController.clear();
          },
        ),
      ),
    );
  }
}

@immutable
abstract class CounterState {
  final int value;

  const CounterState(this.value);
}

class CounterStateValid extends CounterState {
  const CounterStateValid(int value) : super(value);
}

class CounterStateInvalidNumber extends CounterState {
  final String invalidValue;

  const CounterStateInvalidNumber({
    required this.invalidValue,
    required int previousValue,
  }) : super(previousValue);
}

@immutable
class CounterEvent {
  final String value;

  const CounterEvent(this.value);
}

class IncrementEvent extends CounterEvent {
  const IncrementEvent(String value) : super(value);
}

class DecrementEvent extends CounterEvent {
  const DecrementEvent(String value) : super(value);
}

class CounterBloc extends Bloc<CounterEvent, CounterState> {
  CounterBloc() : super(const CounterStateValid(0)) {
    on<IncrementEvent>((event, emmit) {
      final value = int.tryParse(event.value);
      if (value == null) {
        emit(
          CounterStateInvalidNumber(
            invalidValue: event.value,
            previousValue: state.value,
          ),
        );
      } else {
        emit(CounterStateValid(state.value + value));
      }
    });

    on<DecrementEvent>((event, emmit) {
      final value = int.tryParse(event.value);
      if (value == null) {
        emit(
          CounterStateInvalidNumber(
            invalidValue: event.value,
            previousValue: state.value,
          ),
        );
      } else {
        emit(CounterStateValid(state.value - value));
      }
    });
  }
}
