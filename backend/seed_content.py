"""
Скрипт для наполнения базы данных контентом
"""

import os
from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker
from dotenv import load_dotenv

load_dotenv()

DATABASE_URL = os.getenv("POSTGRES_URL", os.getenv("DATABASE_URL", "sqlite:///./zenflow.db"))
if DATABASE_URL.startswith("postgres://"):
    DATABASE_URL = DATABASE_URL.replace("postgres://", "postgresql://", 1)

if "sqlite" in DATABASE_URL:
    engine = create_engine(DATABASE_URL, connect_args={"check_same_thread": False})
else:
    engine = create_engine(DATABASE_URL, pool_pre_ping=True)

SessionLocal = sessionmaker(bind=engine)

# Import after engine setup
from main import ContentDB, Base

Base.metadata.create_all(bind=engine)


CONTENT_DATA = [
    # ============ MEDITATION ============
    # Утро
    {"type": "meditation", "title": "Утреннее пробуждение", "description": "Мягкое пробуждение и настройка на новый день с благодарностью", "duration": "10 мин", "category": "Утро", "level": "Начинающий", "is_premium": False, "instructor": "Анна Светлова", "thumbnail_url": "/images/morning-awakening.jpg", "audio_url": "/audio/morning-awakening.mp3"},
    {"type": "meditation", "title": "Энергия на весь день", "description": "Зарядка энергией через визуализацию и дыхание", "duration": "15 мин", "category": "Утро", "level": "Любой", "is_premium": False, "instructor": "Дмитрий Волков", "thumbnail_url": "/images/energy-boost.jpg", "audio_url": "/audio/energy-boost.mp3"},
    {"type": "meditation", "title": "Осознанное утро", "description": "Практика осознанности для ясного начала дня", "duration": "20 мин", "category": "Утро", "level": "Средний", "is_premium": True, "instructor": "Мария Покровская", "thumbnail_url": "/images/mindful-morning.jpg", "audio_url": "/audio/mindful-morning.mp3"},
    
    # Концентрация
    {"type": "meditation", "title": "Глубокая концентрация", "description": "Развитие способности фокусироваться на одной задаче", "duration": "15 мин", "category": "Концентрация", "level": "Средний", "is_premium": False, "instructor": "Алексей Миронов", "thumbnail_url": "/images/deep-focus.jpg", "audio_url": "/audio/deep-focus.mp3"},
    {"type": "meditation", "title": "Продуктивность без стресса", "description": "Работа в потоке без напряжения", "duration": "12 мин", "category": "Фокус", "level": "Любой", "is_premium": False, "instructor": "Елена Крылова", "thumbnail_url": "/images/productive-calm.jpg", "audio_url": "/audio/productive-calm.mp3"},
    {"type": "meditation", "title": "Ясность ума", "description": "Очищение мыслей и улучшение когнитивных функций", "duration": "20 мин", "category": "Фокус", "level": "Продвинутый", "is_premium": True, "instructor": "Андрей Соколов", "thumbnail_url": "/images/mental-clarity.jpg", "audio_url": "/audio/mental-clarity.mp3"},
    {"type": "meditation", "title": "Перезагрузка", "description": "Быстрое восстановление внимания и сил", "duration": "5 мин", "category": "Продуктивность", "level": "Начинающий", "is_premium": False, "instructor": "Ольга Белова", "thumbnail_url": "/images/reboot.jpg", "audio_url": "/audio/reboot.mp3"},
    
    # Снятие стресса
    {"type": "meditation", "title": "Антистресс", "description": "Глубокая релаксация и снятие напряжения", "duration": "15 мин", "category": "Антистресс", "level": "Начинающий", "is_premium": False, "instructor": "Анна Светлова", "thumbnail_url": "/images/anti-stress.jpg", "audio_url": "/audio/anti-stress.mp3"},
    {"type": "meditation", "title": "Освобождение от тревоги", "description": "Техники работы с тревожными мыслями", "duration": "20 мин", "category": "Антистресс", "level": "Средний", "is_premium": True, "instructor": "Мария Покровская", "thumbnail_url": "/images/anxiety-release.jpg", "audio_url": "/audio/anxiety-release.mp3"},
    {"type": "meditation", "title": "Спокойствие здесь и сейчас", "description": "Возвращение к настоящему моменту", "duration": "10 мин", "category": "Осознанность", "level": "Любой", "is_premium": False, "instructor": "Дмитрий Волков", "thumbnail_url": "/images/present-moment.jpg", "audio_url": "/audio/present-moment.mp3"},
    
    # Вечер
    {"type": "meditation", "title": "Вечерняя благодарность", "description": "Завершение дня с благодарностью", "duration": "10 мин", "category": "Вечер", "level": "Начинающий", "is_premium": False, "instructor": "Елена Крылова", "thumbnail_url": "/images/gratitude.jpg", "audio_url": "/audio/gratitude.mp3"},
    {"type": "meditation", "title": "Отпускание дня", "description": "Освобождение от дневного напряжения", "duration": "15 мин", "category": "Вечер", "level": "Средний", "is_premium": True, "instructor": "Ольга Белова", "thumbnail_url": "/images/let-go.jpg", "audio_url": "/audio/let-go.mp3"},
    
    # ============ YOGA ============
    # Утренняя йога
    {"type": "yoga", "title": "Утренняя виньяса", "description": "Динамичная практика для бодрого начала дня", "duration": "25 мин", "category": "Утренняя йога", "level": "Средний", "is_premium": False, "instructor": "Катерина Лунёва", "thumbnail_url": "/images/morning-vinyasa.jpg", "video_url": "/video/morning-vinyasa.mp4"},
    {"type": "yoga", "title": "Пробуждение тела", "description": "Мягкая практика для постепенного пробуждения", "duration": "15 мин", "category": "Утренняя йога", "level": "Начинающий", "is_premium": False, "instructor": "Ирина Солнцева", "thumbnail_url": "/images/body-awakening.jpg", "video_url": "/video/body-awakening.mp4"},
    {"type": "yoga", "title": "Энергичное утро", "description": "Активная практика с акцентом на прогибы", "duration": "30 мин", "category": "Утренняя йога", "level": "Продвинутый", "is_premium": True, "instructor": "Максим Орлов", "thumbnail_url": "/images/energetic-morning.jpg", "video_url": "/video/energetic-morning.mp4"},
    
    # Хатха йога
    {"type": "yoga", "title": "Хатха для начинающих", "description": "Основы йоги: базовые асаны и выравнивание", "duration": "30 мин", "category": "Хатха йога", "level": "Начинающий", "is_premium": False, "instructor": "Катерина Лунёва", "thumbnail_url": "/images/hatha-beginner.jpg", "video_url": "/video/hatha-beginner.mp4"},
    {"type": "yoga", "title": "Классическая хатха", "description": "Традиционная практика с долгими удержаниями", "duration": "45 мин", "category": "Хатха йога", "level": "Средний", "is_premium": True, "instructor": "Сергей Никитин", "thumbnail_url": "/images/classic-hatha.jpg", "video_url": "/video/classic-hatha.mp4"},
    {"type": "yoga", "title": "Хатха: гибкость", "description": "Работа над гибкостью позвоночника и суставов", "duration": "40 мин", "category": "Хатха йога", "level": "Средний", "is_premium": True, "instructor": "Ирина Солнцева", "thumbnail_url": "/images/hatha-flexibility.jpg", "video_url": "/video/hatha-flexibility.mp4"},
    
    # Виньяса
    {"type": "yoga", "title": "Flow виньяса", "description": "Плавный поток асан в связке с дыханием", "duration": "35 мин", "category": "Виньяса", "level": "Средний", "is_premium": False, "instructor": "Максим Орлов", "thumbnail_url": "/images/flow-vinyasa.jpg", "video_url": "/video/flow-vinyasa.mp4"},
    {"type": "yoga", "title": "Интенсивная виньяса", "description": "Динамичная практика для продвинутых", "duration": "50 мин", "category": "Виньяса", "level": "Продвинутый", "is_premium": True, "instructor": "Максим Орлов", "thumbnail_url": "/images/intense-vinyasa.jpg", "video_url": "/video/intense-vinyasa.mp4"},
    
    # Силовая йога
    {"type": "yoga", "title": "Power Yoga", "description": "Силовая практика для укрепления мышц", "duration": "40 мин", "category": "Силовая йога", "level": "Средний", "is_premium": True, "instructor": "Сергей Никитин", "thumbnail_url": "/images/power-yoga.jpg", "video_url": "/video/power-yoga.mp4"},
    {"type": "yoga", "title": "Йога для кора", "description": "Укрепление мышц живота и спины", "duration": "25 мин", "category": "Силовая йога", "level": "Средний", "is_premium": False, "instructor": "Катерина Лунёва", "thumbnail_url": "/images/core-yoga.jpg", "video_url": "/video/core-yoga.mp4"},
    
    # Инь йога
    {"type": "yoga", "title": "Глубокий инь", "description": "Долгие растяжки для глубокого расслабления", "duration": "45 мин", "category": "Инь йога", "level": "Любой", "is_premium": True, "instructor": "Ирина Солнцева", "thumbnail_url": "/images/deep-yin.jpg", "video_url": "/video/deep-yin.mp4"},
    {"type": "yoga", "title": "Инь для бёдер", "description": "Раскрытие тазобедренных суставов", "duration": "30 мин", "category": "Инь йога", "level": "Начинающий", "is_premium": False, "instructor": "Ирина Солнцева", "thumbnail_url": "/images/yin-hips.jpg", "video_url": "/video/yin-hips.mp4"},
    
    # Вечерняя йога
    {"type": "yoga", "title": "Вечерняя растяжка", "description": "Мягкая практика перед сном", "duration": "20 мин", "category": "Вечерняя йога", "level": "Начинающий", "is_premium": False, "instructor": "Катерина Лунёва", "thumbnail_url": "/images/evening-stretch.jpg", "video_url": "/video/evening-stretch.mp4"},
    {"type": "yoga", "title": "Йога-нидра", "description": "Глубокое расслабление на грани сна", "duration": "35 мин", "category": "Вечерняя йога", "level": "Любой", "is_premium": True, "instructor": "Мария Покровская", "thumbnail_url": "/images/yoga-nidra.jpg", "audio_url": "/audio/yoga-nidra.mp3"},
    
    # ============ SLEEP ============
    # Засыпание
    {"type": "sleep", "title": "Быстрое засыпание", "description": "Расслабление тела и ума для быстрого сна", "duration": "20 мин", "category": "Медитация сна", "level": "Начинающий", "is_premium": False, "instructor": "Анна Светлова", "thumbnail_url": "/images/quick-sleep.jpg", "audio_url": "/audio/quick-sleep.mp3"},
    {"type": "sleep", "title": "Сканирование тела", "description": "Последовательное расслабление всего тела", "duration": "25 мин", "category": "Медитация сна", "level": "Любой", "is_premium": False, "instructor": "Дмитрий Волков", "thumbnail_url": "/images/body-scan.jpg", "audio_url": "/audio/body-scan.mp3"},
    {"type": "sleep", "title": "Глубокий сон", "description": "Медитация для качественного глубокого сна", "duration": "30 мин", "category": "Медитация сна", "level": "Средний", "is_premium": True, "instructor": "Мария Покровская", "thumbnail_url": "/images/deep-sleep.jpg", "audio_url": "/audio/deep-sleep.mp3"},
    
    # Истории
    {"type": "sleep", "title": "Путешествие в горы", "description": "Успокаивающая история о горном путешествии", "duration": "35 мин", "category": "История для сна", "level": "Любой", "is_premium": False, "instructor": "Алексей Миронов", "thumbnail_url": "/images/mountain-story.jpg", "audio_url": "/audio/mountain-story.mp3"},
    {"type": "sleep", "title": "Тихая гавань", "description": "История о плавании к спокойному острову", "duration": "40 мин", "category": "История для сна", "level": "Любой", "is_premium": True, "instructor": "Елена Крылова", "thumbnail_url": "/images/harbor-story.jpg", "audio_url": "/audio/harbor-story.mp3"},
    {"type": "sleep", "title": "Звёздная ночь", "description": "Путешествие среди звёзд", "duration": "30 мин", "category": "История для сна", "level": "Любой", "is_premium": True, "instructor": "Ольга Белова", "thumbnail_url": "/images/starry-night.jpg", "audio_url": "/audio/starry-night.mp3"},
    
    # Звуки природы
    {"type": "sleep", "title": "Дождь за окном", "description": "Звук дождя для умиротворения", "duration": "60 мин", "category": "Природа", "level": "Любой", "is_premium": False, "thumbnail_url": "/images/rain.jpg", "audio_url": "/audio/rain.mp3"},
    {"type": "sleep", "title": "Ночной лес", "description": "Звуки ночного леса: сверчки и совы", "duration": "60 мин", "category": "Природа", "level": "Любой", "is_premium": False, "thumbnail_url": "/images/night-forest.jpg", "audio_url": "/audio/night-forest.mp3"},
    {"type": "sleep", "title": "Океанские волны", "description": "Мягкий шум прибоя", "duration": "60 мин", "category": "Природа", "level": "Любой", "is_premium": False, "thumbnail_url": "/images/ocean-waves.jpg", "audio_url": "/audio/ocean-waves.mp3"},
    {"type": "sleep", "title": "Гроза вдалеке", "description": "Раскаты грома и шум дождя", "duration": "60 мин", "category": "Природа", "level": "Любой", "is_premium": True, "thumbnail_url": "/images/distant-storm.jpg", "audio_url": "/audio/distant-storm.mp3"},
    
    # Амбиент
    {"type": "sleep", "title": "Космическая тишина", "description": "Амбиентная музыка для глубокого сна", "duration": "120 мин", "category": "Амбиент", "level": "Любой", "is_premium": True, "thumbnail_url": "/images/cosmic-silence.jpg", "audio_url": "/audio/cosmic-silence.mp3"},
    {"type": "sleep", "title": "Тибетские чаши", "description": "Поющие чаши для расслабления", "duration": "45 мин", "category": "Амбиент", "level": "Любой", "is_premium": False, "thumbnail_url": "/images/tibetan-bowls.jpg", "audio_url": "/audio/tibetan-bowls.mp3"},
    {"type": "sleep", "title": "Пианино для сна", "description": "Нежные мелодии фортепиано", "duration": "60 мин", "category": "Амбиент", "level": "Любой", "is_premium": True, "thumbnail_url": "/images/piano-sleep.jpg", "audio_url": "/audio/piano-sleep.mp3"},
    
    # ============ ДОПОЛНИТЕЛЬНО ============
    # Дыхание
    {"type": "meditation", "title": "4-7-8 Дыхание", "description": "Техника дыхания для быстрого успокоения", "duration": "8 мин", "category": "Дыхание", "level": "Начинающий", "is_premium": False, "instructor": "Андрей Соколов", "thumbnail_url": "/images/478-breathing.jpg", "audio_url": "/audio/478-breathing.mp3"},
    {"type": "meditation", "title": "Холотропное дыхание", "description": "Интенсивная практика для опытных", "duration": "45 мин", "category": "Дыхание", "level": "Продвинутый", "is_premium": True, "instructor": "Сергей Никитин", "thumbnail_url": "/images/holotropic.jpg", "audio_url": "/audio/holotropic.mp3"},
    {"type": "meditation", "title": "Коробочное дыхание", "description": "Балансирующая техника 4-4-4-4", "duration": "10 мин", "category": "Дыхание", "level": "Любой", "is_premium": False, "instructor": "Дмитрий Волков", "thumbnail_url": "/images/box-breathing.jpg", "audio_url": "/audio/box-breathing.mp3"},
    
    # Специальные
    {"type": "meditation", "title": "Медитация любящей доброты", "description": "Развитие сострадания к себе и другим", "duration": "15 мин", "category": "Сострадание", "level": "Любой", "is_premium": False, "instructor": "Анна Светлова", "thumbnail_url": "/images/loving-kindness.jpg", "audio_url": "/audio/loving-kindness.mp3"},
    {"type": "meditation", "title": "Работа с гневом", "description": "Трансформация гнева в энергию", "duration": "20 мин", "category": "Эмоции", "level": "Средний", "is_premium": True, "instructor": "Мария Покровская", "thumbnail_url": "/images/anger-work.jpg", "audio_url": "/audio/anger-work.mp3"},
    {"type": "meditation", "title": "Прощение", "description": "Медитация для освобождения от обид", "duration": "25 мин", "category": "Эмоции", "level": "Средний", "is_premium": True, "instructor": "Елена Крылова", "thumbnail_url": "/images/forgiveness.jpg", "audio_url": "/audio/forgiveness.mp3"},
    
    # Йога для здоровья
    {"type": "yoga", "title": "Йога для спины", "description": "Снятие напряжения и укрепление спины", "duration": "25 мин", "category": "Здоровье", "level": "Начинающий", "is_premium": False, "instructor": "Катерина Лунёва", "thumbnail_url": "/images/back-yoga.jpg", "video_url": "/video/back-yoga.mp4"},
    {"type": "yoga", "title": "Йога для шеи и плеч", "description": "Расслабление воротниковой зоны", "duration": "20 мин", "category": "Здоровье", "level": "Начинающий", "is_premium": False, "instructor": "Ирина Солнцева", "thumbnail_url": "/images/neck-yoga.jpg", "video_url": "/video/neck-yoga.mp4"},
    {"type": "yoga", "title": "Йога при головной боли", "description": "Мягкие асаны для снятия головной боли", "duration": "15 мин", "category": "Здоровье", "level": "Начинающий", "is_premium": True, "instructor": "Катерина Лунёва", "thumbnail_url": "/images/headache-yoga.jpg", "video_url": "/video/headache-yoga.mp4"},
]


def seed_database():
    """Наполнить базу данных контентом"""
    db = SessionLocal()
    
    try:
        # Проверяем, есть ли уже контент
        existing = db.query(ContentDB).count()
        if existing > 0:
            print(f"База уже содержит {existing} записей. Пропускаем.")
            return
        
        for item in CONTENT_DATA:
            content = ContentDB(
                type=item["type"],
                title=item["title"],
                description=item["description"],
                duration=item.get("duration"),
                category=item.get("category"),
                level=item.get("level"),
                is_premium=item.get("is_premium", False),
                audio_url=item.get("audio_url"),
                video_url=item.get("video_url"),
                thumbnail_url=item.get("thumbnail_url"),
                instructor=item.get("instructor"),
                benefits=item.get("benefits"),
                tags=item.get("tags"),
            )
            db.add(content)
        
        db.commit()
        print(f"✅ Добавлено {len(CONTENT_DATA)} записей в базу данных")
        
    finally:
        db.close()


if __name__ == "__main__":
    seed_database()
