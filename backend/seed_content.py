"""
Seed content for MindGarden app
Run: python seed_content.py
"""

from main import engine, ContentDB, Base
from sqlalchemy.orm import sessionmaker

SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)

# Create all tables
Base.metadata.create_all(bind=engine)

CONTENT = [
    # ==================== МЕДИТАЦИИ ====================
    {
        "type": "meditation",
        "title": "Утреннее пробуждение",
        "description": "Мягкая медитация для начала нового дня с энергией и ясностью",
        "duration": "10 мин",
        "category": "Утро",
        "level": "Начинающий",
        "is_premium": False,
        "audio_url": "https://storage.mindgarden.app/audio/morning-awakening.mp3",
        "thumbnail_url": "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=400",
        "instructor": "Анна Светлова",
        "benefits": "Энергия, ясность ума, позитивный настрой",
        "tags": "утро,энергия,начало дня"
    },
    {
        "type": "meditation",
        "title": "Глубокое расслабление",
        "description": "Погрузитесь в состояние полного покоя и восстановления",
        "duration": "15 мин",
        "category": "Релаксация",
        "level": "Начинающий",
        "is_premium": False,
        "audio_url": "https://storage.mindgarden.app/audio/deep-relaxation.mp3",
        "thumbnail_url": "https://images.unsplash.com/photo-1518241353330-0f7941c2d9b5?w=400",
        "instructor": "Михаил Тихонов",
        "benefits": "Расслабление, снятие напряжения, восстановление",
        "tags": "расслабление,покой,отдых"
    },
    {
        "type": "meditation",
        "title": "Фокус и концентрация",
        "description": "Медитация для повышения продуктивности и ясности мышления",
        "duration": "12 мин",
        "category": "Концентрация",
        "level": "Средний",
        "is_premium": True,
        "audio_url": "https://storage.mindgarden.app/audio/focus-concentration.mp3",
        "thumbnail_url": "https://images.unsplash.com/photo-1499750310107-5fef28a66643?w=400",
        "instructor": "Анна Светлова",
        "benefits": "Фокус, продуктивность, ясность",
        "tags": "фокус,работа,продуктивность"
    },
    {
        "type": "meditation",
        "title": "Благодарность",
        "description": "Практика благодарности для улучшения настроения и взгляда на жизнь",
        "duration": "8 мин",
        "category": "Позитив",
        "level": "Начинающий",
        "is_premium": False,
        "audio_url": "https://storage.mindgarden.app/audio/gratitude.mp3",
        "thumbnail_url": "https://images.unsplash.com/photo-1506784365847-bbad939e9335?w=400",
        "instructor": "Елена Радость",
        "benefits": "Благодарность, позитив, счастье",
        "tags": "благодарность,позитив,радость"
    },
    {
        "type": "meditation",
        "title": "Вечернее отпускание",
        "description": "Отпустите напряжение дня и подготовьтесь к отдыху",
        "duration": "15 мин",
        "category": "Вечер",
        "level": "Начинающий",
        "is_premium": False,
        "audio_url": "https://storage.mindgarden.app/audio/evening-release.mp3",
        "thumbnail_url": "https://images.unsplash.com/photo-1507400492013-162706c8c05e?w=400",
        "instructor": "Михаил Тихонов",
        "benefits": "Отпускание, спокойствие, подготовка ко сну",
        "tags": "вечер,отпускание,покой"
    },
    {
        "type": "meditation",
        "title": "Осознанность в моменте",
        "description": "Научитесь полностью присутствовать в настоящем",
        "duration": "10 мин",
        "category": "Осознанность",
        "level": "Начинающий",
        "is_premium": False,
        "audio_url": "https://storage.mindgarden.app/audio/mindfulness.mp3",
        "thumbnail_url": "https://images.unsplash.com/photo-1545389336-cf090694435e?w=400",
        "instructor": "Анна Светлова",
        "benefits": "Осознанность, присутствие, спокойствие",
        "tags": "осознанность,момент,присутствие"
    },
    {
        "type": "meditation",
        "title": "Сканирование тела",
        "description": "Пройдитесь вниманием по всему телу для глубокого расслабления",
        "duration": "20 мин",
        "category": "Релаксация",
        "level": "Средний",
        "is_premium": True,
        "audio_url": "https://storage.mindgarden.app/audio/body-scan.mp3",
        "thumbnail_url": "https://images.unsplash.com/photo-1544367567-0f2fcb009e0b?w=400",
        "instructor": "Михаил Тихонов",
        "benefits": "Расслабление тела, снятие напряжения",
        "tags": "тело,расслабление,сканирование"
    },
    {
        "type": "meditation",
        "title": "Визуализация успеха",
        "description": "Представьте свой идеальный день и цели",
        "duration": "12 мин",
        "category": "Визуализация",
        "level": "Средний",
        "is_premium": True,
        "audio_url": "https://storage.mindgarden.app/audio/success-visualization.mp3",
        "thumbnail_url": "https://images.unsplash.com/photo-1533073526757-2c8ca1df9f1c?w=400",
        "instructor": "Елена Радость",
        "benefits": "Мотивация, визуализация, цели",
        "tags": "успех,визуализация,цели"
    },
    
    # ==================== ДЫХАТЕЛЬНЫЕ ПРАКТИКИ ====================
    {
        "type": "breathing",
        "title": "Дыхание 4-7-8",
        "description": "Классическая техника для расслабления и засыпания",
        "duration": "5 мин",
        "category": "Расслабление",
        "level": "Начинающий",
        "is_premium": False,
        "audio_url": "https://storage.mindgarden.app/audio/breathing-478.mp3",
        "thumbnail_url": "https://images.unsplash.com/photo-1506126613408-eca07ce68773?w=400",
        "instructor": "Дмитрий Ветров",
        "benefits": "Расслабление, улучшение сна",
        "tags": "4-7-8,сон,расслабление"
    },
    {
        "type": "breathing",
        "title": "Box Breathing",
        "description": "Квадратное дыхание для баланса и концентрации",
        "duration": "7 мин",
        "category": "Фокус",
        "level": "Начинающий",
        "is_premium": False,
        "audio_url": "https://storage.mindgarden.app/audio/box-breathing.mp3",
        "thumbnail_url": "https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?w=400",
        "instructor": "Дмитрий Ветров",
        "benefits": "Баланс, фокус, спокойствие",
        "tags": "квадратное,баланс,фокус"
    },
    {
        "type": "breathing",
        "title": "Энергизирующее дыхание",
        "description": "Быстро поднимите энергию и бодрость",
        "duration": "5 мин",
        "category": "Энергия",
        "level": "Средний",
        "is_premium": False,
        "audio_url": "https://storage.mindgarden.app/audio/energy-breathing.mp3",
        "thumbnail_url": "https://images.unsplash.com/photo-1517836357463-d25dfeac3438?w=400",
        "instructor": "Дмитрий Ветров",
        "benefits": "Энергия, бодрость, пробуждение",
        "tags": "энергия,бодрость,утро"
    },
    {
        "type": "breathing",
        "title": "Дыхание для сна",
        "description": "Мягкая техника для глубокого засыпания",
        "duration": "10 мин",
        "category": "Сон",
        "level": "Начинающий",
        "is_premium": False,
        "audio_url": "https://storage.mindgarden.app/audio/sleep-breathing.mp3",
        "thumbnail_url": "https://images.unsplash.com/photo-1511295742362-92c96b1cf484?w=400",
        "instructor": "Анна Светлова",
        "benefits": "Сон, расслабление, покой",
        "tags": "сон,ночь,засыпание"
    },
    {
        "type": "breathing",
        "title": "Антистресс дыхание",
        "description": "Быстро снизьте напряжение в любой ситуации",
        "duration": "3 мин",
        "category": "Экспресс",
        "level": "Начинающий",
        "is_premium": False,
        "audio_url": "https://storage.mindgarden.app/audio/antistress-breathing.mp3",
        "thumbnail_url": "https://images.unsplash.com/photo-1474418397713-7ede21d49118?w=400",
        "instructor": "Дмитрий Ветров",
        "benefits": "Снятие напряжения, быстрое успокоение",
        "tags": "экспресс,напряжение,быстро"
    },
    {
        "type": "breathing",
        "title": "Дыхание Вима Хофа",
        "description": "Интенсивная практика для энергии и устойчивости",
        "duration": "15 мин",
        "category": "Продвинутый",
        "level": "Продвинутый",
        "is_premium": True,
        "audio_url": "https://storage.mindgarden.app/audio/wim-hof.mp3",
        "thumbnail_url": "https://images.unsplash.com/photo-1518611012118-696072aa579a?w=400",
        "instructor": "Дмитрий Ветров",
        "benefits": "Энергия, устойчивость, закаливание",
        "tags": "вим хоф,энергия,продвинутый"
    },
    
    # ==================== СОН ====================
    {
        "type": "sleep",
        "title": "Ночной лес",
        "description": "Погрузитесь в атмосферу тихого ночного леса",
        "duration": "45 мин",
        "category": "Природа",
        "level": "Начинающий",
        "is_premium": False,
        "audio_url": "https://storage.mindgarden.app/audio/night-forest.mp3",
        "thumbnail_url": "https://images.unsplash.com/photo-1448375240586-882707db888b?w=400",
        "instructor": "Звуки природы",
        "benefits": "Засыпание, спокойствие",
        "tags": "лес,природа,ночь"
    },
    {
        "type": "sleep",
        "title": "Океанские волны",
        "description": "Успокаивающий шум океана для глубокого сна",
        "duration": "60 мин",
        "category": "Природа",
        "level": "Начинающий",
        "is_premium": False,
        "audio_url": "https://storage.mindgarden.app/audio/ocean-waves.mp3",
        "thumbnail_url": "https://images.unsplash.com/photo-1505118380757-91f5f5632de0?w=400",
        "instructor": "Звуки природы",
        "benefits": "Глубокий сон, расслабление",
        "tags": "океан,волны,море"
    },
    {
        "type": "sleep",
        "title": "Дождь за окном",
        "description": "Уютный звук дождя для комфортного засыпания",
        "duration": "60 мин",
        "category": "Природа",
        "level": "Начинающий",
        "is_premium": False,
        "audio_url": "https://storage.mindgarden.app/audio/rain.mp3",
        "thumbnail_url": "https://images.unsplash.com/photo-1515694346937-94d85e41e6f0?w=400",
        "instructor": "Звуки природы",
        "benefits": "Уют, засыпание",
        "tags": "дождь,уют,засыпание"
    },
    {
        "type": "sleep",
        "title": "Сказка на ночь: Путешествие к звёздам",
        "description": "Волшебная история для мягкого погружения в сон",
        "duration": "25 мин",
        "category": "Истории",
        "level": "Начинающий",
        "is_premium": True,
        "audio_url": "https://storage.mindgarden.app/audio/star-journey.mp3",
        "thumbnail_url": "https://images.unsplash.com/photo-1419242902214-272b3f66ee7a?w=400",
        "instructor": "Елена Радость",
        "benefits": "Воображение, засыпание",
        "tags": "история,звёзды,сказка"
    },
    {
        "type": "sleep",
        "title": "Глубокий сон: Йога-нидра",
        "description": "Практика осознанного расслабления для восстановления",
        "duration": "30 мин",
        "category": "Йога-нидра",
        "level": "Средний",
        "is_premium": True,
        "audio_url": "https://storage.mindgarden.app/audio/yoga-nidra.mp3",
        "thumbnail_url": "https://images.unsplash.com/photo-1512621776951-a57141f2eefd?w=400",
        "instructor": "Михаил Тихонов",
        "benefits": "Глубокое восстановление, релаксация",
        "tags": "йога-нидра,восстановление,глубокий сон"
    },
    {
        "type": "sleep",
        "title": "Белый шум",
        "description": "Ровный белый шум для непрерывного сна",
        "duration": "480 мин",
        "category": "Шум",
        "level": "Начинающий",
        "is_premium": False,
        "audio_url": "https://storage.mindgarden.app/audio/white-noise.mp3",
        "thumbnail_url": "https://images.unsplash.com/photo-1478760329108-5c3ed9d495a0?w=400",
        "instructor": "Звуковой фон",
        "benefits": "Маскировка шумов, непрерывный сон",
        "tags": "белый шум,фон,непрерывный"
    },
    
    # ==================== CBT УПРАЖНЕНИЯ ====================
    {
        "type": "cbt",
        "title": "Когнитивная переоценка",
        "description": "Научитесь находить альтернативные взгляды на ситуацию",
        "duration": "10 мин",
        "category": "Мысли",
        "level": "Начинающий",
        "is_premium": False,
        "thumbnail_url": "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400",
        "instructor": "CBT практика",
        "benefits": "Гибкость мышления, новые перспективы",
        "tags": "мысли,переоценка,перспектива"
    },
    {
        "type": "cbt",
        "title": "Дневник мыслей",
        "description": "Записывайте и анализируйте автоматические мысли",
        "duration": "15 мин",
        "category": "Журнал",
        "level": "Начинающий",
        "is_premium": False,
        "thumbnail_url": "https://images.unsplash.com/photo-1517842645767-c639042777db?w=400",
        "instructor": "CBT практика",
        "benefits": "Осознание паттернов, самопознание",
        "tags": "дневник,записи,анализ"
    },
    {
        "type": "cbt",
        "title": "СТОП-техника",
        "description": "Прервите негативный цикл мыслей за 5 шагов",
        "duration": "5 мин",
        "category": "Экспресс",
        "level": "Начинающий",
        "is_premium": False,
        "thumbnail_url": "https://images.unsplash.com/photo-1434030216411-0b793f4b4173?w=400",
        "instructor": "CBT практика",
        "benefits": "Прерывание негатива, контроль",
        "tags": "стоп,экспресс,контроль"
    },
    {
        "type": "cbt",
        "title": "Техника заземления 5-4-3-2-1",
        "description": "Вернитесь в настоящий момент через органы чувств",
        "duration": "5 мин",
        "category": "Заземление",
        "level": "Начинающий",
        "is_premium": False,
        "thumbnail_url": "https://images.unsplash.com/photo-1518241353330-0f7941c2d9b5?w=400",
        "instructor": "CBT практика",
        "benefits": "Заземление, присутствие",
        "tags": "заземление,чувства,момент"
    },
    {
        "type": "cbt",
        "title": "Поведенческая активация",
        "description": "Планируйте приятные и осмысленные действия",
        "duration": "20 мин",
        "category": "Активность",
        "level": "Средний",
        "is_premium": True,
        "thumbnail_url": "https://images.unsplash.com/photo-1484480974693-6ca0a78fb36b?w=400",
        "instructor": "CBT практика",
        "benefits": "Мотивация, планирование",
        "tags": "активация,планирование,действия"
    },
    {
        "type": "cbt",
        "title": "Рефрейминг",
        "description": "Измените восприятие ситуации на более полезное",
        "duration": "10 мин",
        "category": "Мысли",
        "level": "Средний",
        "is_premium": True,
        "thumbnail_url": "https://images.unsplash.com/photo-1522202176988-66273c2fd55f?w=400",
        "instructor": "CBT практика",
        "benefits": "Новый взгляд, гибкость",
        "tags": "рефрейминг,взгляд,изменение"
    },
]


def seed_database():
    """Populate database with content"""
    db = SessionLocal()
    
    try:
        # Clear existing content
        db.query(ContentDB).delete()
        db.commit()
        
        # Add new content
        for item in CONTENT:
            content = ContentDB(**item)
            db.add(content)
        
        db.commit()
        print(f"✅ Successfully added {len(CONTENT)} content items")
        
        # Show summary
        types = {}
        for item in CONTENT:
            t = item["type"]
            types[t] = types.get(t, 0) + 1
        
        print("\n📊 Content summary:")
        for t, count in types.items():
            print(f"  - {t}: {count}")
        
    except Exception as e:
        print(f"❌ Error: {e}")
        db.rollback()
    finally:
        db.close()


if __name__ == "__main__":
    seed_database()
