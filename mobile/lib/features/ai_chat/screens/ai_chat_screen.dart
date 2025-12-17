import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_theme.dart';

class AIChatScreen extends ConsumerStatefulWidget {
  const AIChatScreen({super.key});

  @override
  ConsumerState<AIChatScreen> createState() => _AIChatScreenState();
}

class _AIChatScreenState extends ConsumerState<AIChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<ChatMessage> _messages = [];
  bool _isTyping = false;

  @override
  void initState() {
    super.initState();
    // Add welcome message
    _messages.add(ChatMessage(
      text: 'Привет! 👋 Я твой помощник по здоровому образу жизни. Могу подсказать про питание, сон, физическую активность и восстановление. О чём хочешь поговорить?',
      isUser: false,
      timestamp: DateTime.now(),
    ));
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add(ChatMessage(
        text: text,
        isUser: true,
        timestamp: DateTime.now(),
      ));
      _messageController.clear();
      _isTyping = true;
    });

    _scrollToBottom();

    // Simulate AI response
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) {
        setState(() {
          _isTyping = false;
          _messages.add(ChatMessage(
            text: _getAIResponse(text),
            isUser: false,
            timestamp: DateTime.now(),
          ));
        });
        _scrollToBottom();
      }
    });
  }

  String _getAIResponse(String userMessage) {
    final lowercaseMessage = userMessage.toLowerCase();
    
    // Sleep-related
    if (lowercaseMessage.contains('сон') || lowercaseMessage.contains('спать') || 
        lowercaseMessage.contains('бессонниц') || lowercaseMessage.contains('засып')) {
      return _getSleepAdvice(lowercaseMessage);
    }
    
    // Nutrition-related
    if (lowercaseMessage.contains('еда') || lowercaseMessage.contains('питани') || 
        lowercaseMessage.contains('диет') || lowercaseMessage.contains('есть') ||
        lowercaseMessage.contains('завтрак') || lowercaseMessage.contains('обед') ||
        lowercaseMessage.contains('ужин') || lowercaseMessage.contains('перекус') ||
        lowercaseMessage.contains('калор') || lowercaseMessage.contains('белк') ||
        lowercaseMessage.contains('углевод') || lowercaseMessage.contains('жир')) {
      return _getNutritionAdvice(lowercaseMessage);
    }
    
    // Exercise/Activity-related
    if (lowercaseMessage.contains('спорт') || lowercaseMessage.contains('трениров') || 
        lowercaseMessage.contains('упражнен') || lowercaseMessage.contains('бег') ||
        lowercaseMessage.contains('ходьб') || lowercaseMessage.contains('активност') ||
        lowercaseMessage.contains('фитнес') || lowercaseMessage.contains('йог')) {
      return _getExerciseAdvice(lowercaseMessage);
    }
    
    // Energy/Fatigue-related
    if (lowercaseMessage.contains('устал') || lowercaseMessage.contains('энерги') || 
        lowercaseMessage.contains('сил') || lowercaseMessage.contains('бодр') ||
        lowercaseMessage.contains('вял')) {
      return _getEnergyAdvice(lowercaseMessage);
    }
    
    // Water/Hydration-related
    if (lowercaseMessage.contains('вод') || lowercaseMessage.contains('пить') || 
        lowercaseMessage.contains('жажд') || lowercaseMessage.contains('гидратац')) {
      return _getHydrationAdvice();
    }
    
    // Morning routine
    if (lowercaseMessage.contains('утр') || lowercaseMessage.contains('проснул') ||
        lowercaseMessage.contains('начать день')) {
      return _getMorningAdvice();
    }
    
    // Evening routine
    if (lowercaseMessage.contains('вечер') || lowercaseMessage.contains('ноч') ||
        lowercaseMessage.contains('перед сном')) {
      return _getEveningAdvice();
    }
    
    // Stress (redirect to wellness, not psychology)
    if (lowercaseMessage.contains('стресс') || lowercaseMessage.contains('напряж') ||
        lowercaseMessage.contains('расслаб')) {
      return _getRelaxationAdvice();
    }
    
    // Weight-related
    if (lowercaseMessage.contains('вес') || lowercaseMessage.contains('похуд') ||
        lowercaseMessage.contains('набра')) {
      return _getWeightAdvice(lowercaseMessage);
    }
    
    // General wellness
    if (lowercaseMessage.contains('здоров') || lowercaseMessage.contains('самочувств') ||
        lowercaseMessage.contains('хорош')) {
      return 'Отлично, что ты заботишься о своём здоровье! 🌿\n\nВот несколько ключевых столпов хорошего самочувствия:\n\n💧 Достаточно воды (2-2.5 литра)\n🥗 Сбалансированное питание\n😴 Качественный сон (7-9 часов)\n🏃 Регулярная активность\n🧘 Время для восстановления\n\nО каком аспекте хочешь узнать подробнее?';
    }
    
    // Default response
    return 'Интересный вопрос! Я могу помочь с советами по:\n\n🍎 Питанию и здоровой еде\n😴 Качеству сна и режиму\n💪 Физической активности\n💧 Водному балансу\n⚡ Энергии и восстановлению\n\nО чём из этого хочешь узнать больше?';
  }

  String _getSleepAdvice(String message) {
    if (message.contains('не могу заснуть') || message.contains('бессонниц')) {
      return 'Понимаю, проблемы со сном очень неприятны. Вот несколько советов для лучшего засыпания:\n\n🌙 Техника 4-7-8:\n- Вдох через нос 4 секунды\n- Задержка 7 секунд\n- Выдох через рот 8 секунд\n\n📱 За 1-2 часа до сна:\n- Отложи телефон\n- Приглуши освещение\n- Избегай кофеина после 14:00\n\n🛁 Попробуй:\n- Тёплый душ за 1 час до сна\n- Прохладную комнату (18-20°C)\n- Звуки природы в нашем приложении\n\nХочешь попробовать дыхательную практику прямо сейчас?';
    }
    
    if (message.contains('сколько спать') || message.contains('норма сна')) {
      return 'Оптимальное количество сна для взрослых:\n\n⏰ 7-9 часов в сутки\n\nВажно не только количество, но и качество:\n\n✅ Ложиться и вставать в одно время\n✅ Глубокий сон первые 3-4 часа\n✅ Просыпаться без будильника (в идеале)\n\n💡 Совет: веди дневник сна в нашем приложении, чтобы найти свою идеальную норму!';
    }
    
    return 'Сон — это фундамент здоровья! 😴\n\n🛏 Советы для качественного сна:\n\n1. Режим: ложись и вставай в одно время\n2. Среда: темно, тихо, прохладно\n3. Ритуал: 30-60 мин расслабления перед сном\n4. Питание: лёгкий ужин за 2-3 часа до сна\n5. Активность: не позже чем за 3 часа до сна\n\n🌿 Попробуй наши истории для сна и звуки природы в разделе "Сон"!\n\nЕсть конкретный вопрос про сон?';
  }

  String _getNutritionAdvice(String message) {
    if (message.contains('завтрак')) {
      return 'Идеальный завтрак — это топливо для всего дня! 🍳\n\n✅ Что включить:\n• Белок (яйца, творог, йогурт)\n• Сложные углеводы (овсянка, цельнозерновой хлеб)\n• Полезные жиры (авокадо, орехи)\n• Клетчатка (овощи, фрукты, ягоды)\n\n🕐 Когда:\nВ течение 1-2 часов после пробуждения\n\n💡 Быстрые идеи:\n• Овсянка с ягодами и орехами\n• Яйца + авокадо + овощи\n• Творог с фруктами\n• Смузи с протеином\n\nЗавтрак помогает запустить метаболизм и контролировать аппетит весь день!';
    }
    
    if (message.contains('перекус')) {
      return 'Правильные перекусы — это ключ к стабильной энергии! 🥜\n\n✅ Здоровые варианты:\n• Орехи (горсть 30г)\n• Греческий йогурт\n• Овощные палочки + хумус\n• Фрукты + ореховая паста\n• Варёные яйца\n• Творог с ягодами\n\n❌ Лучше избегать:\n• Сладкие батончики\n• Чипсы и снеки\n• Сладкие напитки\n\n⏰ Оптимально:\n2-3 перекуса между основными приёмами пищи, каждый 100-200 ккал';
    }
    
    if (message.contains('белок') || message.contains('белка')) {
      return 'Белок — строительный материал для тела! 💪\n\n📊 Норма: 1.2-2г на кг веса\n(При 70 кг = 84-140г в день)\n\n🥩 Источники белка:\n• Куриная грудка (31г/100г)\n• Рыба (20-25г/100г)\n• Яйца (13г на 2 шт)\n• Творог (18г/100г)\n• Бобовые (9г/100г)\n• Греческий йогурт (10г/100г)\n\n💡 Совет: распределяй белок равномерно на все приёмы пищи (20-40г за раз) для лучшего усвоения!';
    }
    
    return 'Сбалансированное питание — основа энергии и здоровья! 🥗\n\n🍽 Принципы здорового питания:\n\n1. Разнообразие: разные цвета овощей\n2. Баланс: белки + жиры + углеводы\n3. Регулярность: 3 основных + 2 перекуса\n4. Порции: тарелка = 1/2 овощи, 1/4 белок, 1/4 углеводы\n5. Вода: 2-2.5 литра в день\n\n💡 Хочешь узнать подробнее про:\n• Завтраки?\n• Перекусы?\n• Белки/жиры/углеводы?\n\nПросто спроси!';
  }

  String _getExerciseAdvice(String message) {
    if (message.contains('начать') || message.contains('новичок')) {
      return 'Отлично, что решил начать! 🎉\n\n🏃 План для начинающих:\n\n📅 Неделя 1-2:\n• Ходьба 20-30 мин в день\n• Лёгкая растяжка утром\n• 1-2 йога-сессии в приложении\n\n📅 Неделя 3-4:\n• Увеличь ходьбу до 40-45 мин\n• Добавь 2-3 силовых тренировки\n• Продолжай растяжку\n\n💡 Главное:\n• Не геройствуй в начале\n• Слушай тело\n• Регулярность важнее интенсивности\n• Восстановление — часть тренировок\n\nНачни с раздела "Йога" в нашем приложении!';
    }
    
    if (message.contains('йог')) {
      return 'Йога — отличный выбор! 🧘‍♀️\n\n✨ Польза йоги:\n• Гибкость и подвижность\n• Сила и выносливость\n• Лучший сон\n• Снижение напряжения в теле\n• Осознанность\n\n📱 В нашем приложении:\n• Йога для начинающих (15-20 мин)\n• Утренние практики\n• Йога перед сном\n• Растяжка после тренировок\n\n💡 Совет: начни с 2-3 раз в неделю по 15-20 минут. Заходи в раздел "Йога"!';
    }
    
    return 'Движение — это жизнь! 💪\n\n🎯 Рекомендации ВОЗ:\n• 150-300 мин умеренной активности в неделю\n• ИЛИ 75-150 мин интенсивной\n• Силовые упражнения 2+ раз в неделю\n\n🏃 Виды активности:\n• Ходьба (самое простое!)\n• Бег / велосипед\n• Силовые тренировки\n• Йога и растяжка\n• Плавание\n\n💡 Совет: выбери то, что нравится — так легче сделать это привычкой!\n\nХочешь план для начинающих или что-то конкретное?';
  }

  String _getEnergyAdvice(String message) {
    if (message.contains('устал') || message.contains('нет сил')) {
      return 'Понимаю, усталость мешает жить полноценно. Давай разберёмся! 🔋\n\n⚡ Быстрые способы восполнить энергию:\n\n1. 💧 Выпей стакан воды (обезвоживание = усталость)\n2. 🚶 Пройдись 10-15 минут на свежем воздухе\n3. 🧘 Сделай 5-минутную дыхательную практику\n4. 🍎 Перекуси белком + сложными углеводами\n\n📋 Проверь базу:\n• Сон: 7-9 часов?\n• Вода: 2+ литра?\n• Еда: регулярная?\n• Движение: есть?\n\nЧто из этого можно улучшить?';
    }
    
    return 'Энергия зависит от нескольких факторов! ⚡\n\n🔋 Источники энергии:\n\n1. 😴 Качественный сон (7-9 часов)\n2. 🍽 Сбалансированное питание\n3. 💧 Достаточно воды\n4. 🏃 Регулярная активность\n5. ☀️ Солнечный свет\n6. 🧘 Время на восстановление\n\n💡 Для стабильной энергии:\n• Ешь регулярно (каждые 3-4 часа)\n• Избегай сахарных пиков\n• Двигайся каждый час\n• Делай паузы\n\nО чём хочешь узнать подробнее?';
  }

  String _getHydrationAdvice() {
    return 'Вода — основа жизни! 💧\n\n📊 Сколько пить:\n• Базово: 30-35 мл на кг веса\n• При 70 кг = 2.1-2.5 литра\n• При нагрузках: +0.5-1 литр\n\n🕐 Как распределить:\n• Стакан после пробуждения\n• По стакану перед каждым приёмом пищи\n• Бутылка воды всегда под рукой\n• Приложение-напоминалка\n\n✅ Признаки достаточной гидратации:\n• Светлая моча\n• Нет жажды\n• Хорошая энергия\n• Чистая кожа\n\n💡 Совет: носи бутылку 0.5л и выпивай 4-5 таких в день!';
  }

  String _getMorningAdvice() {
    return 'Правильное утро задаёт тон всему дню! ☀️\n\n🌅 Идеальное утро:\n\n1. 💧 Стакан воды сразу после пробуждения\n2. 🌿 5-10 мин растяжки или йоги\n3. ☀️ Открой шторы — свет будит\n4. 🍳 Питательный завтрак\n5. 📱 Не хватай телефон первые 30 мин\n\n⏰ Полезные привычки:\n• Просыпайся в одно время\n• Не откладывай будильник\n• Проветри комнату\n• Контрастный душ (по желанию)\n\n📱 Попробуй нашу "Утреннюю практику" — 10 мин для бодрого начала дня!';
  }

  String _getEveningAdvice() {
    return 'Вечерний ритуал важен для качественного сна! 🌙\n\n🌃 Идеальный вечер:\n\n⏰ За 2-3 часа до сна:\n• Лёгкий ужин\n• Заверши дела\n• Подготовь всё на завтра\n\n⏰ За 1-2 часа:\n• Приглуши свет\n• Отложи телефон\n• Тёплый душ или ванна\n\n⏰ За 30 мин:\n• Медитация или дыхание\n• Чтение (бумажная книга)\n• Лёгкая растяжка\n\n📱 В нашем приложении:\n• Вечерняя медитация\n• Истории для сна\n• Звуки природы\n\nПопробуй раздел "Сон"!';
  }

  String _getRelaxationAdvice() {
    return 'Расслабление тела важно для восстановления! 🧘\n\n✨ Физические способы снять напряжение:\n\n1. 🌬 Дыхание 4-7-8\n   Вдох 4 сек → Пауза 7 сек → Выдох 8 сек\n\n2. 💆 Прогрессивная релаксация:\n   Напряги мышцы на 5 сек → расслабь\n   Пройди от ступней до головы\n\n3. 🧘 Лёгкая йога или растяжка\n\n4. 🛁 Тёплая ванна или душ\n\n5. 🎧 Звуки природы\n\n📱 Попробуй раздел "Дыхание" в приложении — там есть интерактивные практики!\n\nКакой способ хочешь попробовать?';
  }

  String _getWeightAdvice(String message) {
    if (message.contains('похуд') || message.contains('сбросить')) {
      return 'Устойчивое снижение веса строится на привычках! 🎯\n\n📊 Базовые принципы:\n\n1. Дефицит калорий 300-500 ккал/день\n2. Достаточно белка (1.5-2г/кг)\n3. Регулярная активность\n4. Качественный сон\n5. Терпение (0.5-1 кг в неделю — норма)\n\n✅ Фокус на привычках:\n• Осознанное питание\n• Больше овощей и белка\n• Регулярные приёмы пищи\n• Движение каждый день\n• Достаточно воды\n\n⚠️ Важно: не гонись за быстрым результатом — он редко устойчив!\n\nХочешь советы по питанию или активности?';
    }
    
    return 'Здоровый вес — это баланс! ⚖️\n\n🎯 Ключевые факторы:\n\n• 🍽 Питание (70% успеха)\n• 🏃 Активность (20%)\n• 😴 Сон и восстановление (10%)\n\n💡 Советы:\n• Не считай только калории\n• Фокусируйся на качестве еды\n• Двигайся каждый день\n• Спи 7-9 часов\n• Пей достаточно воды\n• Будь терпелив\n\nО чём хочешь узнать подробнее — питание или активность?';
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.eco_rounded, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 12),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Wellness-помощник',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  'Питание • Сон • Активность',
                  style: TextStyle(
                    fontSize: 11,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // Quick topics
          Container(
            height: 44,
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                _buildQuickTopic('🍎 Питание', 'Что поесть на завтрак?'),
                _buildQuickTopic('😴 Сон', 'Как улучшить сон?'),
                _buildQuickTopic('💪 Спорт', 'С чего начать тренировки?'),
                _buildQuickTopic('💧 Вода', 'Сколько пить воды?'),
                _buildQuickTopic('⚡ Энергия', 'Как повысить энергию?'),
              ],
            ),
          ),
          
          // Messages
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _messages.length + (_isTyping ? 1 : 0),
              itemBuilder: (context, index) {
                if (_isTyping && index == _messages.length) {
                  return _buildTypingIndicator();
                }
                return _buildMessageBubble(_messages[index]);
              },
            ),
          ),
          
          // Input
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              border: Border(
                top: BorderSide(color: AppColors.primary.withOpacity(0.1)),
              ),
            ),
            child: SafeArea(
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.background,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: AppColors.primary.withOpacity(0.2)),
                      ),
                      child: TextField(
                        controller: _messageController,
                        style: const TextStyle(color: AppColors.textPrimary),
                        decoration: const InputDecoration(
                          hintText: 'Спроси про питание, сон, спорт...',
                          hintStyle: TextStyle(color: AppColors.textMuted, fontSize: 14),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        ),
                        maxLines: 3,
                        minLines: 1,
                        onSubmitted: (_) => _sendMessage(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  GestureDetector(
                    onTap: _sendMessage,
                    child: Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        gradient: AppColors.primaryGradient,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withOpacity(0.4),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const Icon(Icons.send_rounded, color: Colors.white, size: 22),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickTopic(String label, String message) {
    return GestureDetector(
      onTap: () {
        _messageController.text = message;
        _sendMessage();
      },
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.primary.withOpacity(0.2)),
        ),
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            color: AppColors.textSecondary,
          ),
        ),
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage message) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: message.isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!message.isUser) ...[
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.eco_rounded, color: Colors.white, size: 18),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                gradient: message.isUser 
                  ? AppColors.primaryGradient
                  : null,
                color: message.isUser ? null : AppColors.surface,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(20),
                  topRight: const Radius.circular(20),
                  bottomLeft: Radius.circular(message.isUser ? 20 : 4),
                  bottomRight: Radius.circular(message.isUser ? 4 : 20),
                ),
                border: message.isUser 
                  ? null 
                  : Border.all(color: AppColors.primary.withOpacity(0.2)),
              ),
              child: Text(
                message.text,
                style: TextStyle(
                  fontSize: 15,
                  color: message.isUser ? Colors.white : AppColors.textPrimary,
                  height: 1.4,
                ),
              ),
            ),
          ),
          if (message.isUser) const SizedBox(width: 40),
        ],
      ),
    );
  }

  Widget _buildTypingIndicator() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.eco_rounded, color: Colors.white, size: 18),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.primary.withOpacity(0.2)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(3, (index) {
                return TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0.0, end: 1.0),
                  duration: Duration(milliseconds: 600 + (index * 200)),
                  builder: (context, value, child) {
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 2),
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.3 + (value * 0.5)),
                        shape: BoxShape.circle,
                      ),
                    );
                  },
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}

class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;

  ChatMessage({
    required this.text,
    required this.isUser,
    required this.timestamp,
  });
}
