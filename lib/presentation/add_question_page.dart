import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_app_quize/data/models/question.dart';
import 'package:material_app_quize/data/providers/theme_provider.dart';
import 'package:material_app_quize/logic/bloc/question_bloc.dart';
import 'package:provider/provider.dart';

class AddQuestionPage extends StatefulWidget {
  const AddQuestionPage({Key? key}) : super(key: key);

  @override
  _AddQuestionPageState createState() => _AddQuestionPageState();
}

class _AddQuestionPageState extends State<AddQuestionPage> {
  get themeTextController => null;

  @override
  Widget build(BuildContext context) {
    QuestionsBloc bloc = BlocProvider.of<QuestionsBloc>(context);
    final categoryTextControler = TextEditingController();
    final questionTextController = TextEditingController();
    final imageUrlTextController = TextEditingController();
    final ansTextController = TextEditingController();
    return ChangeNotifierProvider(
        create: (context) => ThemeProvider(),
        builder: (context, _) {
          final themeProvider = Provider.of<ThemeProvider>(context);
          return Container(
            color: Theme.of(context).scaffoldBackgroundColor,
            child: BlocProvider(
              create: (context) => QuestionsBloc(),
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 32),
                    child: Text(
                      "Ajout d'une question ",
                      style: TextStyle(
                          fontSize: 30, color: Theme.of(context).primaryColor),
                    ),
                  ),
                  Container(
                      margin: EdgeInsets.only(top: 16),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          controller: questionTextController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Question ',
                            hintText: 'La question a affiché ',
                          ),
                        ),
                      )),
                  Container(
                      margin: EdgeInsets.only(top: 16),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          controller: categoryTextControler,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Category',
                            hintText: 'categorie de la question ',
                          ),
                        ),
                      )),
                  Container(
                      margin: EdgeInsets.only(top: 16),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          controller: ansTextController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'La reponse',
                            hintText: 'vrai / faux ',
                          ),
                        ),
                      )),
                  Container(
                      margin: EdgeInsets.only(top: 16),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          controller: imageUrlTextController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Image',
                            hintText: "L'image lié a la question (lien)",
                          ),
                        ),
                      )),
                  Center(
                      child: MaterialButton(
                    onPressed: () {
                      String qst_text = questionTextController.text;
                      String image_url = imageUrlTextController.text;
                      String category = categoryTextControler.text;
                      bool ans = false;
                      if (ansTextController.text == "v") {
                        ans = true;
                      }
                      bloc.add(AddQuestionsEvent(Question(
                          qstText: qst_text,
                          imageUrl: image_url,
                          ans: ans,
                          category: category)));
                      /*fireStoreRepository
                      .addQuestion(Question(
                          qstText: qst_text,
                          imageUrl: image_url,
                          ans: ans,
                          category: category))
                      .then((value) {
                    final snackBar = SnackBar(
                      content: Text(" question ajoué"),
                    );*/
                      /* ScaffoldMessenger.of(context).showSnackBar(snackBar);*/

                      categoryTextControler.text = "";
                      questionTextController.text = "";
                      imageUrlTextController.text = "";
                      ansTextController.text = "";

                      bloc.add(FetchQuestionsEvent());
                    },
                    child: Text(
                      "Ajouter",
                      style: TextStyle(color: Colors.white),
                    ),
                    color: Theme.of(context).primaryColor,
                  ))
                ],
              ),
            ),
          );
        });
  }
}
