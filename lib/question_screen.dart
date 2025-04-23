import 'dart:async';
import 'package:flutter/material.dart';

class QuestionScreen extends StatefulWidget {
  final String subject;
  final String mode;

  const QuestionScreen({super.key, required this.subject, required this.mode});

  @override
  _QuestionScreenState createState() => _QuestionScreenState();
}

class _QuestionScreenState extends State<QuestionScreen>
    with SingleTickerProviderStateMixin {
  final List<Map<String, String>> _questions = [
    {
      'question': 'Вопрос 1: Сколько будет 2 + 2?',
      'option1': '3',
      'option2': '4',
      'option3': '5',
      'correctAnswer': '4',
    },
    {
      'question':
          'Вопрос 2: Какой газ составляет большую часть атмосферы Земли?',
      'option1': 'Кислород',
      'option2': 'Азот',
      'option3': 'Углекислый газ',
      'correctAnswer': 'Азот',
    },
    {
      'question': 'Вопрос 3: Что тяжелее 1 кг железа?',
      'option1': '1 кг пуха',
      'option2': '1 кг воды',
      'option3': 'Ничего из вышеперечисленного',
      'correctAnswer': 'Ничего из вышеперечисленного',
    },
  ];

  int _currentQuestionIndex = 0;
  int _remainingTime = 10;
  int _correctAnswers = 0;
  Timer? _timer;

  // Цвета из иконки
  final List<Color> _gradientColors = [
    const Color(0xFF00C4FF), // Голубой
    const Color(0xFFFF66CC), // Розовый
    const Color(0xFFFF00FF), // Фиолетовый
  ];

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingTime > 0) {
          _remainingTime--;
        } else {
          _nextQuestion(null);
        }
      });
    });
  }

  void _answerQuestion(String selectedAnswer) {
    final correctAnswer = _questions[_currentQuestionIndex]['correctAnswer']!;
    if (selectedAnswer == correctAnswer) {
      setState(() {
        _correctAnswers++;
      });
    }
    _nextQuestion(selectedAnswer);
  }

  void _nextQuestion(String? selectedAnswer) {
    _timer?.cancel();
    if (_currentQuestionIndex < _questions.length - 1) {
      setState(() {
        _currentQuestionIndex++;
        _remainingTime = 10;
      });
      _startTimer();
    } else {
      _showResults();
    }
  }

  void _showResults() {
    _timer?.cancel();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Результаты'),
        content: Text(
          'Вы завершили тест!\nПравильных ответов: $_correctAnswers из ${_questions.length}',
        ),
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.pop(context); // Закрываем диалог
              Navigator.pop(context); // Возвращаемся на предыдущий экран
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
                'ОК',
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

  @override
  Widget build(BuildContext context) {
    final question = _questions[_currentQuestionIndex];
    return Scaffold(
      appBar: AppBar(
        title: Text('Тест: ${widget.subject} (${widget.mode})'),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.white,
              Colors.grey[100]!,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Индикатор прогресса
              Text(
                'Вопрос ${_currentQuestionIndex + 1} из ${_questions.length}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 8),
              LinearProgressIndicator(
                value: (_currentQuestionIndex + 1) / _questions.length,
                backgroundColor: Colors.grey[300],
                valueColor: AlwaysStoppedAnimation<Color>(
                  const Color(0xFFFF66CC),
                ),
              ),
              const SizedBox(height: 24),
              // Вопрос
              Container(
                padding: const EdgeInsets.all(16),
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.9,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      blurRadius: 8,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Text(
                  question['question']!,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 24),
              // Варианты ответов
              Column(
                children: [
                  _buildAnswerButton(question['option1']!),
                  _buildAnswerButton(question['option2']!),
                  _buildAnswerButton(question['option3']!),
                ],
              ),
              const SizedBox(height: 24),
              // Таймер
              Text(
                'Оставшееся время: $_remainingTime секунд',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
              const SizedBox(height: 24),
              // Кнопка пропуска
              _buildSkipButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAnswerButton(String option) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: GestureDetector(
        onTap: () => _answerQuestion(option),
        child: Container(
          width: MediaQuery.of(context).size.width * 0.8,
          padding: const EdgeInsets.symmetric(vertical: 16),
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
          child: Center(
            child: Text(
              option,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSkipButton() {
    return GestureDetector(
      onTap: () => _nextQuestion(null),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        padding: const EdgeInsets.symmetric(vertical: 16),
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
        child: const Center(
          child: Text(
            'Пропустить',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}
