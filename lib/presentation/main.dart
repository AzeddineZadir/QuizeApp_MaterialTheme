import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_app_quize/data/providers/theme_provider.dart';
import 'package:material_app_quize/presentation/widgets/dark_button_widget.dart';
import 'package:provider/provider.dart';

import '../logic/bloc/question_bloc.dart';
import 'add_question_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => QuestionsBloc(),
      child: ChangeNotifierProvider(
          create: (context) => ThemeProvider(),
          builder: (context, _) {
            final themeProvider = Provider.of<ThemeProvider>(context);
            return MaterialApp(
              themeMode: themeProvider.themeMode,
              theme: MyThemes.lightTheme,
              darkTheme: MyThemes.darkTheme,
              routes: {
                "/": (context) => MyHomePage(
                      title: 'QuizeAPP',
                    )
              },
            );
          }),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    QuestionsBloc bloc = BlocProvider.of<QuestionsBloc>(context);
    bloc.add(FetchQuestionsEvent());
    int index = 0;
    String snackMessage = "";

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Theme.of(context).primaryColor,
        actions: [
          DarkThemeButton(),
        ],
      ),
      body: BlocBuilder<QuestionsBloc, QuestionState>(
        builder: (context, state) {
          if (state is QuestionLoadedState) {
            return Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                  Expanded(
                    flex: 3,
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Container(
                        color: Colors.white,
                        child: Image(
                          image:
                              NetworkImage(state.listQuestion[index].imageUrl),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                      flex: 2,
                      child: Container(
                          margin: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Theme.of(context).scaffoldBackgroundColor,
                          ),
                          child: Center(
                            child: Text(
                              state.listQuestion[index].qstText,
                              style: TextStyle(
                                fontSize: 20.0,
                              ),
                            ),
                          ))),
                  Expanded(
                      child: Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ElevatedButton(
                              onPressed: () {
                                if (state.listQuestion[index].ans) {
                                  snackMessage = "The answer is correct";
                                  final snackBar = SnackBar(
                                    content: Text(snackMessage),
                                    action: SnackBarAction(
                                      label: 'next question',
                                      onPressed: () {
                                        if (index !=
                                            state.listQuestion.length - 1) {
                                          index++;
                                        } else {
                                          index = 0;
                                        }
                                        bloc.add(FetchQuestionsEvent());
                                      },
                                    ),
                                  );

                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(snackBar);
                                } else {
                                  snackMessage = "Sorry,Try again";
                                  final snackBar = SnackBar(
                                    content: Text(snackMessage),
                                  );
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(snackBar);
                                }
                              },
                              child: Text("Vrai")),
                        ),
                      ),
                      Expanded(
                        child: ElevatedButton(
                            onPressed: () {
                              if (state.listQuestion[index].ans == false) {
                                snackMessage = "The answer is correct";
                                final snackBar = SnackBar(
                                  content: Text(snackMessage),
                                  action: SnackBarAction(
                                    label: 'next question',
                                    onPressed: () {
                                      if (state.listQuestion[index].ans ==
                                          false) {
                                        snackMessage = "The answer is correct";
                                        final snackBar = SnackBar(
                                          content: Text(snackMessage),
                                          action: SnackBarAction(
                                            label: 'next question',
                                            onPressed: () {
                                              if (index !=
                                                  state.listQuestion.length -
                                                      1) {
                                                index++;
                                              } else {
                                                index = 0;
                                              }
                                              bloc.add(FetchQuestionsEvent());
                                            },
                                          ),
                                        );

                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(snackBar);
                                      } else {
                                        snackMessage = "Sorry,Try again";
                                        final snackBar = SnackBar(
                                          content: Text(snackMessage),
                                        );
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(snackBar);
                                      }
                                    },
                                  ),
                                );

                                ScaffoldMessenger.of(context)
                                    .showSnackBar(snackBar);
                              } else {
                                snackMessage = "Sorry,Try again";
                                final snackBar = SnackBar(
                                  content: Text(snackMessage),
                                );
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(snackBar);
                              }
                            },
                            child: Text("Faux")),
                      ),
                    ],
                  )),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                        onPressed: () {
                          if (index != state.listQuestion.length - 1) {
                            index++;
                          } else {
                            index = 0;
                          }
                          bloc.add(FetchQuestionsEvent());
                        },
                        child: Icon(
                          Icons.arrow_forward,
                        )),
                  )
                ]));
          } else if (state is QuestionLoadingState) {
            return CircularProgressIndicator();
          } else {
            return Text("errr");
          }
        },
      ),
      drawer: AddQuestionPage(),
    );
  }
}
