import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login_screen.dart';
import 'question_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  String _selectedMode = 'Экзамен';
  String _selectedTestCategory = 'ОРТ';
  String _selectedSubject = 'Математика';
  String? _selectedTest; // Для отслеживания выбранного теста
  String? _selectedSubjectTest; // Для отслеживания выбранного предмета
  final List<String> _testCategories = ['ОРТ', 'ЕНТ', 'SAT', 'ЕГЭ'];

  // Список предметов в формате словарей
  final List<Map<String, String>> _subjects = [
    {'name': 'Математика', 'description': 'Тест по математике'},
    {'name': 'Физика', 'description': 'Тест по физике'},
    {'name': 'Химия', 'description': 'Тест по химии'},
    {'name': 'Биология', 'description': 'Тест по биологии'},
  ];

  // Динамические данные для тестов (только основные тесты)
  final Map<String, Map<String, List<Map<String, String>>>> _testData = {
    'ОРТ': {
      'main': [
        {
          'name': 'Государственный язык',
          'description': 'Тест по языку для ОРТ'
        },
        {'name': 'Математика', 'description': 'Базовая математика для ОРТ'},
      ],
    },
    'ЕНТ': {
      'main': [
        {'name': 'Казахский язык', 'description': 'Тест по языку для ЕНТ'},
        {'name': 'Математика', 'description': 'Базовая математика для ЕНТ'},
      ],
    },
    'SAT': {
      'main': [
        {'name': 'Математика', 'description': 'Математика для SAT'},
        {'name': 'Чтение', 'description': 'Чтение и анализ текста'},
      ],
    },
    'ЕГЭ': {
      'main': [
        {
          'name': 'Русский язык',
          'description': 'Тест по русскому языку для ЕГЭ'
        },
        {'name': 'Математика', 'description': 'Базовая математика для ЕГЭ'},
      ],
    },
  };

  // Цвета из иконки
  final List<Color> _gradientColors = [
    const Color(0xFF00C4FF), // Голубой
    const Color(0xFFFF66CC), // Розовый
    const Color(0xFFFF00FF), // Фиолетовый
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _startTest(BuildContext context, String testName) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Запущен тест: $testName')),
    );
  }

  void _startQuestionFlow(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => QuestionScreen(
          subject: _selectedSubject,
          mode: _selectedMode,
        ),
      ),
    );
  }

  void _showStartTestDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Начать тест по предмету: $_selectedSubject'),
        content: Text(
            'Вы выбрали тест: $_selectedTestCategory ($_selectedMode). Начать?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Отмена'),
          ),
          GestureDetector(
            onTap: () {
              Navigator.pop(context); // Закрываем диалог
              _startQuestionFlow(context); // Запускаем тест
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: _gradientColors,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFFF66CC).withOpacity(0.3),
                    blurRadius: 8,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: const Text(
                'Начать тест',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow(
                      color: Colors.black,
                      offset: Offset(1, 1),
                      blurRadius: 2,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _handleMenuSelection(BuildContext context, String value) async {
    switch (value) {
      case 'theme':
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Функция смены темы пока не реализована')),
        );
        break;
      case 'logout':
        try {
          await FirebaseAuth.instance.signOut();
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const LoginScreen()),
          );
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Ошибка при выходе: $e')),
          );
        }
        break;
      case 'profile':
        _showProfileDialog(context);
        break;
    }
  }

  void _showProfileDialog(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Профиль'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Имя: ${user?.displayName ?? 'Не указано'}'),
            const SizedBox(height: 8),
            Text('Email: ${user?.email ?? 'Не указано'}'),
            const SizedBox(height: 8),
            const Text('Описание: Студент, готовлюсь к экзаменам'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Закрыть'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final mainTests = _testData[_selectedTestCategory]!['main']!;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Название'),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.settings),
            onSelected: (value) => _handleMenuSelection(context, value),
            itemBuilder: (BuildContext context) => [
              const PopupMenuItem<String>(
                value: 'theme',
                child: Row(
                  children: [
                    Icon(Icons.palette, color: Colors.grey),
                    SizedBox(width: 10),
                    Text('Тема'),
                  ],
                ),
              ),
              const PopupMenuItem<String>(
                value: 'logout',
                child: Row(
                  children: [
                    Icon(Icons.logout, color: Colors.grey),
                    SizedBox(width: 10),
                    Text('Выйти'),
                  ],
                ),
              ),
              const PopupMenuItem<String>(
                value: 'profile',
                child: Row(
                  children: [
                    Icon(Icons.person, color: Colors.grey),
                    SizedBox(width: 10),
                    Text('Профиль'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          // Фильтр: Экзамен или Практика
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _selectedMode = 'Экзамен';
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _selectedMode == 'Экзамен'
                        ? const Color(0xFFFF66CC)
                        : Colors.grey[300],
                  ),
                  child: const Text('Экзамен'),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _selectedMode = 'Практика';
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _selectedMode == 'Практика'
                        ? const Color(0xFFFF66CC)
                        : Colors.grey[300],
                  ),
                  child: const Text('Практика'),
                ),
              ],
            ),
          ),
          // Горизонтальный скролл категорий тестов
          SizedBox(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemCount: _testCategories.length,
              itemBuilder: (context, index) {
                final category = _testCategories[index];
                final isSelected = category == _selectedTestCategory;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedTestCategory = category;
                        _selectedTest = null;
                        _selectedSubjectTest =
                            null; // Сброс выбранного предмета
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        gradient: isSelected
                            ? LinearGradient(
                                colors: _gradientColors,
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              )
                            : null,
                        color: isSelected ? null : Colors.grey[200],
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: isSelected
                              ? const Color(0xFFFF66CC)
                              : Colors.grey,
                          width: isSelected ? 2 : 1,
                        ),
                        boxShadow: isSelected
                            ? [
                                BoxShadow(
                                  color:
                                      const Color(0xFFFF66CC).withOpacity(0.3),
                                  blurRadius: 8,
                                  spreadRadius: 2,
                                ),
                              ]
                            : [],
                      ),
                      child: Center(
                        child: Text(
                          category,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.normal,
                            color: isSelected ? Colors.white : Colors.black,
                            shadows: isSelected
                                ? [
                                    const Shadow(
                                      color: Colors.black,
                                      offset: Offset(1, 1),
                                      blurRadius: 2,
                                    ),
                                  ]
                                : [],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 16),
          // Основные тесты и предметы
          Expanded(
            child: ListView(
              children: [
                // Основные тесты
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    'Основные тесты ($_selectedTestCategory)',
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(
                  height: 120,
                  child: mainTests.isEmpty
                      ? const Center(child: Text('Нет основных тестов'))
                      : ListView.builder(
                          scrollDirection: Axis.horizontal,
                          physics: const BouncingScrollPhysics(),
                          itemCount: mainTests.length,
                          itemBuilder: (context, index) {
                            final test = mainTests[index];
                            final isSelected = test['name'] == _selectedTest;
                            return RepaintBoundary(
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _selectedTest = test['name'];
                                    });
                                    if (_selectedMode == 'Экзамен') {
                                      _startTest(
                                          context, '${test['name']} (Экзамен)');
                                    } else {
                                      _startTest(context,
                                          '${test['name']} (Практика)');
                                    }
                                  },
                                  child: Container(
                                    width: 100,
                                    decoration: BoxDecoration(
                                      gradient: isSelected
                                          ? LinearGradient(
                                              colors: _gradientColors,
                                              begin: Alignment.topLeft,
                                              end: Alignment.bottomRight,
                                            )
                                          : null,
                                      color:
                                          isSelected ? null : Colors.grey[200],
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                        color: isSelected
                                            ? const Color(0xFFFF66CC)
                                            : Colors.grey,
                                      ),
                                      boxShadow: isSelected
                                          ? [
                                              BoxShadow(
                                                color: const Color(0xFFFF66CC)
                                                    .withOpacity(0.3),
                                                blurRadius: 8,
                                                spreadRadius: 2,
                                              ),
                                            ]
                                          : [],
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          test['name']!,
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: isSelected
                                                ? Colors.white
                                                : Colors.black,
                                            shadows: isSelected
                                                ? [
                                                    const Shadow(
                                                      color: Colors.black,
                                                      offset: Offset(1, 1),
                                                      blurRadius: 2,
                                                    ),
                                                  ]
                                                : [],
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          test['description']!,
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: isSelected
                                                ? Colors.white70
                                                : Colors.grey,
                                          ),
                                          textAlign: TextAlign.center,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                ),
                const SizedBox(height: 16),
                // Предметы
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: const Text(
                    'Предметы',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(
                  height: 120,
                  child: _subjects.isEmpty
                      ? const Center(child: Text('Нет предметов'))
                      : ListView.builder(
                          scrollDirection: Axis.horizontal,
                          physics: const BouncingScrollPhysics(),
                          itemCount: _subjects.length,
                          itemBuilder: (context, index) {
                            final subject = _subjects[index];
                            final isSelected =
                                subject['name'] == _selectedSubjectTest;
                            return RepaintBoundary(
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _selectedSubjectTest = subject['name'];
                                      _selectedSubject = subject['name']!;
                                    });
                                    _showStartTestDialog(context);
                                  },
                                  child: Container(
                                    width: 100,
                                    decoration: BoxDecoration(
                                      gradient: isSelected
                                          ? LinearGradient(
                                              colors: _gradientColors,
                                              begin: Alignment.topLeft,
                                              end: Alignment.bottomRight,
                                            )
                                          : null,
                                      color:
                                          isSelected ? null : Colors.grey[200],
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                        color: isSelected
                                            ? const Color(0xFFFF66CC)
                                            : Colors.grey,
                                      ),
                                      boxShadow: isSelected
                                          ? [
                                              BoxShadow(
                                                color: const Color(0xFFFF66CC)
                                                    .withOpacity(0.3),
                                                blurRadius: 8,
                                                spreadRadius: 2,
                                              ),
                                            ]
                                          : [],
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          subject['name']!,
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: isSelected
                                                ? Colors.white
                                                : Colors.black,
                                            shadows: isSelected
                                                ? [
                                                    const Shadow(
                                                      color: Colors.black,
                                                      offset: Offset(1, 1),
                                                      blurRadius: 2,
                                                    ),
                                                  ]
                                                : [],
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          subject['description']!,
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: isSelected
                                                ? Colors.white70
                                                : Colors.grey,
                                          ),
                                          textAlign: TextAlign.center,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
