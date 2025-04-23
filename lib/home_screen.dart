import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  String _selectedMode = 'Экзамен';
  String _selectedTestCategory = 'ОРТ';
  final List<String> _testCategories = ['ОРТ', 'ЕНТ', 'SAT', 'ЕГЭ'];

  // Динамические данные для тестов
  final Map<String, Map<String, List<Map<String, String>>>> _testData = {
    'ОРТ': {
      'main': [
        {
          'name': 'Государственный язык',
          'description': 'Тест по языку для ОРТ'
        },
        {'name': 'Математика', 'description': 'Базовая математика для ОРТ'},
      ],
      'subjects': [
        {'name': 'Математика', 'description': 'Углубленный тест по математике'},
        {'name': 'Физика', 'description': 'Тест по физике для ОРТ'},
        {'name': 'Химия', 'description': 'Тест по химии для ОРТ'},
      ],
    },
    'ЕНТ': {
      'main': [
        {'name': 'Казахский язык', 'description': 'Тест по языку для ЕНТ'},
        {'name': 'Математика', 'description': 'Базовая математика для ЕНТ'},
      ],
      'subjects': [
        {'name': 'Биология', 'description': 'Тест по биологии для ЕНТ'},
        {'name': 'География', 'description': 'Тест по географии для ЕНТ'},
      ],
    },
    'SAT': {
      'main': [
        {'name': 'Математика', 'description': 'Математика для SAT'},
        {'name': 'Чтение', 'description': 'Чтение и анализ текста'},
      ],
      'subjects': [
        {'name': 'Письмо', 'description': 'Тест по письму для SAT'},
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
      'subjects': [
        {'name': 'Физика', 'description': 'Тест по физике для ЕГЭ'},
        {'name': 'Химия', 'description': 'Тест по химии для ЕГЭ'},
        {'name': 'История', 'description': 'Тест по истории для ЕГЭ'},
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
    final subjectTests = _testData[_selectedTestCategory]!['subjects']!;

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
                        ? const Color(
                            0xFFFF66CC) // Используем розовый из иконки
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
                            color: isSelected
                                ? Colors
                                    .white // Белый текст для контраста с градиентом
                                : Colors.black,
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
          // Тесты в виде иконок
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
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: mainTests.length,
                    itemBuilder: (context, index) {
                      final test = mainTests[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: GestureDetector(
                          onTap: () {
                            if (_selectedMode == 'Экзамен') {
                              _startTest(context, '${test['name']} (Экзамен)');
                            } else {
                              _startTest(context, '${test['name']} (Практика)');
                            }
                          },
                          child: Container(
                            width: 100,
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.grey),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  test['name']!,
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  test['description']!,
                                  style: const TextStyle(
                                      fontSize: 12, color: Colors.grey),
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16),
                // Предметные тесты
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    'Предметные тесты ($_selectedTestCategory)',
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(
                  height: 120,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: subjectTests.length,
                    itemBuilder: (context, index) {
                      final test = subjectTests[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: GestureDetector(
                          onTap: () {
                            if (_selectedMode == 'Экзамен') {
                              _startTest(context, '${test['name']} (Экзамен)');
                            } else {
                              _startTest(context, '${test['name']} (Практика)');
                            }
                          },
                          child: Container(
                            width: 100,
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.grey),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  test['name']!,
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  test['description']!,
                                  style: const TextStyle(
                                      fontSize: 12, color: Colors.grey),
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
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
