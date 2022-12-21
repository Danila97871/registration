import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      routes: {
        '/': (BuildContext context)  => MyHomePage(title: 'Форма хахаделичности'),
      },
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primarySwatch: Colors.blue,
          useMaterial3: true
      ),

    );
  }
}

//Состояние для основного экрана
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}


enum Gender {Man, Woman}

//класс формы
class RegistrationForm{
  String fio = '';
  bool protect = false;
  double Count = 1;
  Gender? gender = Gender.Man;
  List<String> xaxas = <String>['ха-ха', 'хи-хи', 'хе-хе'];
  String? favorite = '';

  RegistrationForm(){
    favorite = xaxas.first;
  }

}

//Второй экран
class SecondScreen extends StatelessWidget{
  const SecondScreen({super.key, required this.form});

  final RegistrationForm form;

  @override
  Widget build(BuildContext context){
    return Scaffold(
        appBar: AppBar(
          title: const Text('Вывод - вы шиз'),
        ),
        body: Container(
          height: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),


          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //TODO: Доделать отображение данных с формы
                Text('Ваше имя ${form.fio.toString()}'),
                if (form.gender == Gender.Woman)
                  const Text('Вы указали что вы немнощька (клоун)')
                else
                  const Text('Вы указали что вы да (клоун)'),
                if (form.protect) ... [
                  const Text('Вы подтвердили что вы любите похихикать'),
                  Text('Вы хотите ${form.Count.toInt().toString()} раз посмеятся'),
                  Text('Вы указали что вам больше всего нравиться ${form.favorite.toString()}'),
                  const Text('Все ЪУЬ:'),
                  ListView.builder(
                      padding: const EdgeInsets.all(8),
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      itemCount: form.xaxas.length,
                      itemBuilder: (BuildContext context, int index){
                        return Text(form.xaxas[index]);
                      }
                  ),
                ]
                else
                  const Text('Вы больше не смешной ;('),




              ]),)
    );
  }
}

//Основной экран
class _MyHomePageState extends State<MyHomePage> {

  final _formKey = GlobalKey<FormState>();
  RegistrationForm formData = RegistrationForm();
  bool accessData = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
          alignment: Alignment.topLeft,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          width: 500,
          child: Form(
            key: _formKey,
            onChanged: () {Form.of(primaryFocus!.context!)!.save();},
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    decoration: const InputDecoration (
                        icon: Icon(Icons.person),
                        labelText: 'Имя'
                    ),
                    onSaved: (String? value) {
                      if (value != null) {
                        formData.fio = value;
                      }


                    },
                    validator: (String? args) {
                      if (args!.isEmpty) return 'Введите имя';
                    },

                  ),
                  const Padding(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      child:Align(
                        alignment: Alignment.topLeft,
                        child: Text('Вы клоун?'),
                      )),
                  RadioListTile(
                      title: const Text('Да'),
                      value: Gender.Man,
                      groupValue: formData.gender,
                      onChanged: (Gender? value) {setState(() {formData.gender = value;});}
                  ),
                  RadioListTile(
                      title: const Text('Немнощька'),
                      value: Gender.Woman,
                      groupValue: formData.gender,
                      onChanged: (Gender? value) {setState(() {formData.gender = value;});}
                  ),
                  Row(children: [
                    const Text('Вы любите похихикать?'),
                    Checkbox(
                        value: formData.protect,
                        onChanged: (bool? value) {setState(() {
                          if (value != null) {
                            formData.protect = value;
                          }
                        });}),
                  ]),
                  Row(
                    children: [
                      const Text('Подпишите мою петицию'),
                      Switch(
                          value: accessData,
                          onChanged: (bool? value) {
                            setState(() {
                              if (value != null)
                                accessData = value;
                            });
                          }
                      )
                    ],
                  ),
                  if (formData.protect) ... [
                    const Text('Выбери своего бойца'),
                    Padding(
                        padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                        child: DropdownButton(
                            items: formData.xaxas.map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            value: formData.favorite,
                            onChanged: (String? value) {setState(() {
                              formData.favorite = value;
                            });}
                        )
                    ),
                    const Text('Сколько вы бы хотели хаха в день?'),
                    Slider(
                      value: formData.Count,
                      onChanged: (double? value) {setState(() {
                        if (value != null) {
                          formData.Count = value;
                        }
                      });},
                      min: 1,
                      max: 6,
                      divisions: 5,
                      label: formData.Count.toInt().toString(),
                    )
                  ],



                  Padding(
                      padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                      child: ElevatedButton(

                          onPressed: () {
                            if (accessData){
                              if(_formKey.currentState!.validate()){
                                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Маладес'), backgroundColor: Colors.green,));
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) => SecondScreen(form: formData)));
                              }
                            }
                            else{
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Вы не подписали мою петицию'), backgroundColor: Colors.red,));
                            }
                          },
                          child: const Text('Проверить форму'))
                  )
                ]
            ),
          )
      ),
    );
  }
}
