"use client";

import { useState, useEffect, useRef } from "react";
import { motion, useScroll, useTransform, AnimatePresence } from "framer-motion";

// ============ ICONS ============
const Icons = {
  mind: (
    <svg viewBox="0 0 24 24" fill="currentColor" className="w-8 h-8">
      <path d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm-2 15l-5-5 1.41-1.41L10 14.17l7.59-7.59L19 8l-9 9z" />
    </svg>
  ),
  leaf: (
    <svg viewBox="0 0 24 24" fill="currentColor" className="w-8 h-8">
      <path d="M17,8C8,10 5.9,16.17 3.82,21.34L5.71,22L6.66,19.7C7.14,19.87 7.64,20 8,20C19,20 22,3 22,3C21,5 14,5.25 9,6.25C4,7.25 2,11.5 2,13.5C2,15.5 3.75,17.25 3.75,17.25C7,8 17,8 17,8Z" />
    </svg>
  ),
  heart: (
    <svg viewBox="0 0 24 24" fill="currentColor" className="w-6 h-6">
      <path d="M12 21.35l-1.45-1.32C5.4 15.36 2 12.28 2 8.5 2 5.42 4.42 3 7.5 3c1.74 0 3.41.81 4.5 2.09C13.09 3.81 14.76 3 16.5 3 19.58 3 22 5.42 22 8.5c0 3.78-3.4 6.86-8.55 11.54L12 21.35z" />
    </svg>
  ),
  star: (
    <svg viewBox="0 0 24 24" fill="currentColor" className="w-5 h-5">
      <path d="M12 2l3.09 6.26L22 9.27l-5 4.87 1.18 6.88L12 17.77l-6.18 3.25L7 14.14 2 9.27l6.91-1.01L12 2z" />
    </svg>
  ),
  check: (
    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="3" className="w-5 h-5">
      <path d="M5 13l4 4L19 7" strokeLinecap="round" strokeLinejoin="round" />
    </svg>
  ),
  chevron: (
    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" className="w-5 h-5">
      <path d="M6 9l6 6 6-6" strokeLinecap="round" strokeLinejoin="round" />
    </svg>
  ),
  menu: (
    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" className="w-6 h-6">
      <path d="M4 6h16M4 12h16M4 18h16" strokeLinecap="round" />
    </svg>
  ),
  close: (
    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" className="w-6 h-6">
      <path d="M6 18L18 6M6 6l12 12" strokeLinecap="round" strokeLinejoin="round" />
    </svg>
  ),
  appStore: (
    <svg viewBox="0 0 24 24" fill="currentColor" className="w-6 h-6">
      <path d="M18.71 19.5c-.83 1.24-1.71 2.45-3.05 2.47-1.34.03-1.77-.79-3.29-.79-1.53 0-2 .77-3.27.82-1.31.05-2.3-1.32-3.14-2.53C4.25 17 2.94 12.45 4.7 9.39c.87-1.52 2.43-2.48 4.12-2.51 1.28-.02 2.5.87 3.29.87.78 0 2.26-1.07 3.81-.91.65.03 2.47.26 3.64 1.98-.09.06-2.17 1.28-2.15 3.81.03 3.02 2.65 4.03 2.68 4.04-.03.07-.42 1.44-1.38 2.83M13 3.5c.73-.83 1.94-1.46 2.94-1.5.13 1.17-.34 2.35-1.04 3.19-.69.85-1.83 1.51-2.95 1.42-.15-1.15.41-2.35 1.05-3.11z" />
    </svg>
  ),
  playStore: (
    <svg viewBox="0 0 24 24" fill="currentColor" className="w-6 h-6">
      <path d="M3 20.5v-17c0-.59.34-1.11.84-1.35L13.69 12l-9.85 9.85c-.5-.25-.84-.76-.84-1.35zm13.81-5.38L6.05 21.34l8.49-8.49 2.27 2.27zm3.35-4.31c.34.27.54.68.54 1.19s-.2.92-.54 1.19l-2.12 1.24-2.5-2.5 2.5-2.5 2.12 1.38zM6.05 2.66l10.76 6.22-2.27 2.27-8.49-8.49z" />
    </svg>
  ),
  brain: (
    <svg viewBox="0 0 24 24" fill="currentColor" className="w-6 h-6">
      <path d="M12 2a9 9 0 0 0-9 9c0 4.17 2.84 7.67 6.69 8.69L12 22l2.31-2.31C18.16 18.67 21 15.17 21 11a9 9 0 0 0-9-9zm0 16c-3.87 0-7-3.13-7-7s3.13-7 7-7 7 3.13 7 7-3.13 7-7 7z"/>
      <circle cx="9" cy="10" r="1.5"/>
      <circle cx="15" cy="10" r="1.5"/>
      <path d="M12 14c1.66 0 3-1 3-2.5H9c0 1.5 1.34 2.5 3 2.5z"/>
    </svg>
  ),
  breathing: (
    <svg viewBox="0 0 24 24" fill="currentColor" className="w-6 h-6">
      <path d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm0 18c-4.42 0-8-3.58-8-8s3.58-8 8-8 8 3.58 8 8-3.58 8-8 8z"/>
      <path d="M12 6c-3.31 0-6 2.69-6 6s2.69 6 6 6 6-2.69 6-6-2.69-6-6-6zm0 10c-2.21 0-4-1.79-4-4s1.79-4 4-4 4 1.79 4 4-1.79 4-4 4z"/>
    </svg>
  ),
};

// ============ ANIMATED COUNTER ============
function AnimatedCounter({ value, suffix = "" }: { value: number; suffix?: string }) {
  const [count, setCount] = useState(0);
  const ref = useRef<HTMLDivElement>(null);
  const [isVisible, setIsVisible] = useState(false);

  useEffect(() => {
    const observer = new IntersectionObserver(
      ([entry]) => {
        if (entry.isIntersecting) {
          setIsVisible(true);
        }
      },
      { threshold: 0.3 }
    );

    if (ref.current) observer.observe(ref.current);
    return () => observer.disconnect();
  }, []);

  useEffect(() => {
    if (!isVisible) return;
    const duration = 2000;
    const steps = 60;
    const increment = value / steps;
    let current = 0;
    const timer = setInterval(() => {
      current += increment;
      if (current >= value) {
        setCount(value);
        clearInterval(timer);
      } else {
        setCount(Math.floor(current));
      }
    }, duration / steps);
    return () => clearInterval(timer);
  }, [isVisible, value]);

  return (
    <div ref={ref} className="text-5xl md:text-6xl font-bold text-white font-serif">
      {count.toLocaleString()}{suffix}
    </div>
  );
}

// ============ ORGANIC BLOB ============
function OrganicBlob({ className = "" }: { className?: string }) {
  return (
    <div className={`absolute animate-blob animate-pulse-soft ${className}`}>
      <div className="w-full h-full bg-gradient-to-br from-emerald-500/20 to-green-600/10 rounded-full blur-3xl" />
    </div>
  );
}

// ============ FLOATING LEAVES ============
function FloatingElements() {
  return (
    <div className="absolute inset-0 overflow-hidden pointer-events-none">
      {[...Array(20)].map((_, i) => (
        <motion.div
          key={i}
          className="absolute w-2 h-2 bg-emerald-400/20 rounded-full"
          initial={{
            x: Math.random() * (typeof window !== "undefined" ? window.innerWidth : 1000),
            y: typeof window !== "undefined" ? window.innerHeight + 50 : 1000,
          }}
          animate={{
            y: -100,
            x: `+=${Math.sin(i) * 100}`,
            opacity: [0, 0.6, 0],
            scale: [0.5, 1, 0.5],
          }}
          transition={{
            duration: Math.random() * 15 + 10,
            repeat: Infinity,
            delay: Math.random() * 10,
            ease: "linear",
          }}
        />
      ))}
    </div>
  );
}

// ============ TESTIMONIAL CARD ============
const testimonials = [
  {
    name: "Анна К.",
    role: "Маркетолог, 32 года",
    text: "После 3 месяцев использования я научилась управлять тревожностью. Ежедневные практики и AI-собеседник помогли понять мои триггеры.",
    avatar: "🌿",
    rating: 5,
    improvement: "Тревожность снизилась на 67%",
  },
  {
    name: "Максим П.",
    role: "Разработчик, 28 лет",
    text: "CBT-упражнения реально работают! Раньше я не верил в такие приложения, но результаты говорят сами за себя.",
    avatar: "💚",
    rating: 5,
    improvement: "Качество сна улучшилось",
  },
  {
    name: "Елена С.",
    role: "Предприниматель",
    text: "Трекер настроения открыл глаза на мои эмоциональные паттерны. Теперь я понимаю, что влияет на моё состояние.",
    avatar: "🍃",
    rating: 5,
    improvement: "Осознанность выросла",
  },
  {
    name: "Дмитрий В.",
    role: "Врач, 41 год",
    text: "Как специалист, могу сказать — подход научно обоснован. Рекомендую пациентам как дополнение к основной поддержке.",
    avatar: "🌱",
    rating: 5,
    improvement: "Рекомендую коллегам",
  },
];

function TestimonialCarousel() {
  const [current, setCurrent] = useState(0);

  useEffect(() => {
    const timer = setInterval(() => {
      setCurrent((prev) => (prev + 1) % testimonials.length);
    }, 6000);
    return () => clearInterval(timer);
  }, []);

  return (
    <div className="relative max-w-4xl mx-auto">
      <AnimatePresence mode="wait">
        <motion.div
          key={current}
          initial={{ opacity: 0, y: 30 }}
          animate={{ opacity: 1, y: 0 }}
          exit={{ opacity: 0, y: -30 }}
          transition={{ duration: 0.5 }}
          className="glass rounded-[2rem] p-8 md:p-12 relative overflow-hidden"
        >
          {/* Decorative element */}
          <div className="absolute top-0 right-0 w-32 h-32 bg-gradient-to-br from-emerald-500/10 to-transparent rounded-full blur-2xl" />
          
          <div className="flex gap-1 mb-6">
            {[...Array(testimonials[current].rating)].map((_, i) => (
              <span key={i} className="text-emerald-400">{Icons.star}</span>
            ))}
          </div>
          
          <p className="text-xl md:text-2xl text-white/90 mb-6 leading-relaxed font-light">
            &ldquo;{testimonials[current].text}&rdquo;
          </p>
          
          <div className="inline-block px-4 py-2 bg-emerald-500/10 rounded-full text-emerald-400 text-sm font-medium mb-6">
            {testimonials[current].improvement}
          </div>
          
          <div className="flex items-center gap-4">
            <span className="text-4xl">{testimonials[current].avatar}</span>
            <div>
              <div className="font-semibold text-white">{testimonials[current].name}</div>
              <div className="text-white/50">{testimonials[current].role}</div>
            </div>
          </div>
        </motion.div>
      </AnimatePresence>
      
      <div className="flex justify-center gap-2 mt-8">
        {testimonials.map((_, i) => (
          <button
            key={i}
            onClick={() => setCurrent(i)}
            className={`h-2 rounded-full transition-all duration-300 ${
              i === current ? "bg-emerald-500 w-8" : "bg-white/20 w-2 hover:bg-white/30"
            }`}
          />
        ))}
      </div>
    </div>
  );
}

// ============ PRICING CARD ============
function PricingCard({
  title,
  price,
  period,
  features,
  popular,
  cta,
  description,
}: {
  title: string;
  price: string;
  period: string;
  features: string[];
  popular?: boolean;
  cta: string;
  description: string;
}) {
  return (
    <motion.div
      whileHover={{ y: -8 }}
      transition={{ type: "spring", stiffness: 300 }}
      className={`relative rounded-[2rem] p-8 ${
        popular
          ? "bg-gradient-to-br from-emerald-600 to-green-700 shadow-2xl shadow-emerald-500/20"
          : "glass"
      }`}
    >
      {popular && (
        <div className="absolute -top-4 left-1/2 -translate-x-1/2 bg-gradient-to-r from-amber-400 to-orange-400 text-black text-sm font-bold px-5 py-1.5 rounded-full shadow-lg">
          Лучший выбор
        </div>
      )}
      
      <h3 className="text-2xl font-bold text-white mb-2 font-serif">{title}</h3>
      <p className="text-white/60 text-sm mb-6">{description}</p>
      
      <div className="mb-8">
        <span className="text-5xl font-bold text-white font-serif">{price}</span>
        <span className="text-white/60 ml-2">{period}</span>
      </div>
      
      <ul className="space-y-4 mb-8">
        {features.map((feature, i) => (
          <li key={i} className="flex items-start gap-3 text-white/90">
            <span className={`mt-0.5 ${popular ? "text-white" : "text-emerald-400"}`}>{Icons.check}</span>
            <span>{feature}</span>
          </li>
        ))}
      </ul>
      
      <button
        className={`w-full py-4 rounded-xl font-semibold transition-all ${
          popular
            ? "bg-white text-emerald-700 hover:bg-gray-100 shadow-lg"
            : "bg-emerald-600 text-white hover:bg-emerald-500"
        }`}
      >
        {cta}
      </button>
    </motion.div>
  );
}

// ============ FAQ ITEM ============
function FAQItem({ question, answer }: { question: string; answer: string }) {
  const [isOpen, setIsOpen] = useState(false);

  return (
    <div className="border-b border-white/10">
      <button
        onClick={() => setIsOpen(!isOpen)}
        className="w-full py-6 flex justify-between items-center text-left group"
      >
        <span className="text-lg font-medium text-white pr-4 group-hover:text-emerald-400 transition-colors">{question}</span>
        <motion.span
          animate={{ rotate: isOpen ? 180 : 0 }}
          className="text-emerald-400 flex-shrink-0"
        >
          {Icons.chevron}
        </motion.span>
      </button>
      <AnimatePresence>
        {isOpen && (
          <motion.div
            initial={{ height: 0, opacity: 0 }}
            animate={{ height: "auto", opacity: 1 }}
            exit={{ height: 0, opacity: 0 }}
            transition={{ duration: 0.3 }}
            className="overflow-hidden"
          >
            <p className="pb-6 text-white/60 leading-relaxed">{answer}</p>
          </motion.div>
        )}
      </AnimatePresence>
    </div>
  );
}

// ============ FEATURE CARD ============
function FeatureCard({ icon, title, description, color }: { icon: string; title: string; description: string; color: string }) {
  return (
    <motion.div
      initial={{ opacity: 0, y: 20 }}
      whileInView={{ opacity: 1, y: 0 }}
      viewport={{ once: true }}
      whileHover={{ y: -5 }}
      className="group glass rounded-[1.5rem] p-8 card-hover relative overflow-hidden"
    >
      <div className={`absolute top-0 right-0 w-24 h-24 ${color} rounded-full blur-3xl opacity-20 group-hover:opacity-40 transition-opacity`} />
      <div className="text-5xl mb-5">{icon}</div>
      <h3 className="text-xl font-semibold text-white mb-3 font-serif">{title}</h3>
      <p className="text-white/60 leading-relaxed">{description}</p>
    </motion.div>
  );
}

// ============ MAIN PAGE ============
export default function LandingPage() {
  const [mobileMenuOpen, setMobileMenuOpen] = useState(false);
  const { scrollYProgress } = useScroll();
  const heroOpacity = useTransform(scrollYProgress, [0, 0.15], [1, 0]);
  const heroScale = useTransform(scrollYProgress, [0, 0.15], [1, 0.98]);

  const features = [
    {
      icon: "🧘",
      title: "Медитации и практики",
      description: "200+ аудио-сессий для расслабления, концентрации и эмоционального баланса",
      color: "bg-emerald-500",
    },
    {
      icon: "🌬️",
      title: "Дыхательные техники",
      description: "Научно обоснованные методы: 4-7-8, box breathing, когерентное дыхание",
      color: "bg-teal-500",
    },
    {
      icon: "📝",
      title: "CBT-упражнения",
      description: "Когнитивно-поведенческие практики для работы с мыслями и эмоциями",
      color: "bg-green-500",
    },
    {
      icon: "📊",
      title: "Трекер настроения",
      description: "Отслеживайте эмоции, находите паттерны, понимайте себя лучше",
      color: "bg-lime-500",
    },
    {
      icon: "💬",
      title: "AI-собеседник",
      description: "Безопасное пространство для разгрузки мыслей и рефлексии 24/7",
      color: "bg-emerald-400",
    },
    {
      icon: "🌙",
      title: "Сон и восстановление",
      description: "Истории для сна, звуки природы и техники для глубокого отдыха",
      color: "bg-cyan-500",
    },
  ];

  const faqs = [
    {
      question: "Это замена психологу или психотерапевту?",
      answer: "Нет. MindGarden — это инструмент самопомощи и поддержки ментального благополучия. Мы не предоставляем медицинских услуг и не заменяем профессиональную помощь. При серьёзных проблемах рекомендуем обратиться к специалисту. Мы сотрудничаем с психологами, которые могут помочь вам дополнительно.",
    },
    {
      question: "Как работает AI-собеседник?",
      answer: "AI-собеседник — это безопасное пространство для размышлений и рефлексии. Он задаёт открытые вопросы, помогает структурировать мысли и применять CBT-техники. Все диалоги конфиденциальны и не хранятся на серверах.",
    },
    {
      question: "Подойдёт ли мне, если я никогда не медитировал?",
      answer: "Абсолютно! Мы разработали специальную программу для начинающих. Начните с 3-минутных практик и постепенно увеличивайте время. Наши инструкции понятны и не требуют опыта.",
    },
    {
      question: "Можно ли отменить подписку?",
      answer: "Да, подписку можно отменить в любой момент в настройках приложения. Доступ сохранится до конца оплаченного периода. Никаких скрытых платежей.",
    },
    {
      question: "Мои данные в безопасности?",
      answer: "Да. Мы используем шифрование данных, не передаём информацию третьим лицам и не используем ваши записи для обучения AI. Вы можете удалить все данные в любой момент.",
    },
  ];

  return (
    <div className="min-h-screen bg-[#0C1810] text-white overflow-x-hidden">
      {/* Background elements */}
      <div className="fixed inset-0 pointer-events-none">
        <OrganicBlob className="top-0 left-0 w-[600px] h-[600px] -translate-x-1/2 -translate-y-1/2" />
        <OrganicBlob className="bottom-0 right-0 w-[800px] h-[800px] translate-x-1/3 translate-y-1/3" />
        <OrganicBlob className="top-1/2 left-1/2 w-[400px] h-[400px] -translate-x-1/2 -translate-y-1/2 opacity-30" />
      </div>
      <FloatingElements />

      {/* Navigation */}
      <nav className="fixed top-0 left-0 right-0 z-50 glass">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="flex justify-between items-center h-20">
            <div className="flex items-center gap-3">
              <div className="w-10 h-10 rounded-xl bg-gradient-to-br from-emerald-400 to-green-600 flex items-center justify-center">
                {Icons.leaf}
            </div>
              <span className="text-xl font-bold text-white font-serif">MindGarden</span>
            </div>
            
            <div className="hidden md:flex items-center gap-8">
              <a href="#features" className="text-white/70 hover:text-emerald-400 transition font-medium">
                Возможности
              </a>
              <a href="#how-it-works" className="text-white/70 hover:text-emerald-400 transition font-medium">
                Как это работает
              </a>
              <a href="#pricing" className="text-white/70 hover:text-emerald-400 transition font-medium">
                Тарифы
              </a>
              <a href="#faq" className="text-white/70 hover:text-emerald-400 transition font-medium">
                FAQ
              </a>
              <button className="btn-primary px-6 py-2.5 rounded-full font-semibold text-white relative z-10">
                Скачать бесплатно
              </button>
            </div>
            
            <button className="md:hidden text-white" onClick={() => setMobileMenuOpen(!mobileMenuOpen)}>
              {mobileMenuOpen ? Icons.close : Icons.menu}
            </button>
          </div>
        </div>
        
        {/* Mobile menu */}
        <AnimatePresence>
          {mobileMenuOpen && (
            <motion.div
              initial={{ opacity: 0, height: 0 }}
              animate={{ opacity: 1, height: "auto" }}
              exit={{ opacity: 0, height: 0 }}
              className="md:hidden bg-[#0C1810]/95 backdrop-blur-xl border-t border-white/10"
            >
              <div className="px-4 py-6 space-y-4">
                <a href="#features" className="block text-white/70 hover:text-emerald-400 py-2">Возможности</a>
                <a href="#how-it-works" className="block text-white/70 hover:text-emerald-400 py-2">Как это работает</a>
                <a href="#pricing" className="block text-white/70 hover:text-emerald-400 py-2">Тарифы</a>
                <a href="#faq" className="block text-white/70 hover:text-emerald-400 py-2">FAQ</a>
                <button className="w-full btn-primary py-4 rounded-xl font-semibold text-white mt-4">
                  Скачать бесплатно
                </button>
              </div>
            </motion.div>
          )}
        </AnimatePresence>
      </nav>

      {/* Hero Section */}
      <motion.section
        style={{ opacity: heroOpacity, scale: heroScale }}
        className="relative min-h-screen flex items-center justify-center pt-20"
      >
        <div className="relative max-w-7xl mx-auto px-4 text-center">
          <motion.div
            initial={{ opacity: 0, y: 30 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ duration: 0.8 }}
          >
            {/* Badge */}
            <div className="inline-flex items-center gap-3 glass rounded-full px-5 py-2.5 mb-8">
              <span className="w-2 h-2 bg-emerald-400 rounded-full animate-pulse" />
              <span className="text-sm text-white/80">Инструмент для заботы о себе</span>
              <span className="text-xs px-2 py-0.5 bg-emerald-500/20 text-emerald-400 rounded-full">Не медицинское приложение</span>
            </div>
            
            <h1 className="text-5xl md:text-7xl lg:text-8xl font-bold mb-8 leading-[1.1] font-serif">
              <span className="text-white">Ваш личный</span>
              <br />
              <span className="gradient-text">сад для души</span>
            </h1>
            
            <p className="text-xl md:text-2xl text-white/60 mb-12 max-w-3xl mx-auto leading-relaxed font-light">
              Ежедневные практики осознанности, дыхательные техники и AI-поддержка 
              для вашего ментального благополучия. Начните заботиться о себе уже сегодня.
            </p>
            
            <div className="flex flex-col sm:flex-row gap-4 justify-center mb-16">
              <motion.button
                whileHover={{ scale: 1.03 }}
                whileTap={{ scale: 0.98 }}
                className="flex items-center justify-center gap-3 bg-white text-[#0C1810] px-8 py-4 rounded-2xl font-semibold text-lg shadow-xl shadow-white/10 hover:shadow-white/20 transition-shadow"
              >
                {Icons.appStore}
                App Store
              </motion.button>
              <motion.button
                whileHover={{ scale: 1.03 }}
                whileTap={{ scale: 0.98 }}
                className="flex items-center justify-center gap-3 glass px-8 py-4 rounded-2xl font-semibold text-lg hover:bg-white/10 transition"
              >
                {Icons.playStore}
                Google Play
              </motion.button>
            </div>
            
            {/* App Preview */}
            <div className="relative max-w-sm mx-auto">
              <div className="absolute -inset-8 bg-gradient-to-r from-emerald-500/30 to-green-600/20 rounded-[4rem] blur-3xl" />
              <motion.div 
                className="relative"
                animate={{ y: [0, -10, 0] }}
                transition={{ duration: 4, repeat: Infinity, ease: "easeInOut" }}
              >
                <div className="bg-gradient-to-br from-emerald-900/50 to-green-900/30 rounded-[2.5rem] p-3 shadow-2xl border border-emerald-500/20">
                  <div className="bg-[#0C1810] rounded-[2rem] overflow-hidden aspect-[9/19]">
                  <div className="h-full flex flex-col">
                    {/* Status bar */}
                    <div className="flex justify-between items-center px-6 py-3 text-xs text-white/60">
                      <span>9:41</span>
                        <div className="w-24 h-7 bg-black rounded-full" />
                        <span className="flex items-center gap-1">
                          <svg className="w-4 h-4" viewBox="0 0 24 24" fill="currentColor">
                            <path d="M12 21.35l-1.45-1.32C5.4 15.36 2 12.28 2 8.5 2 5.42 4.42 3 7.5 3c1.74 0 3.41.81 4.5 2.09C13.09 3.81 14.76 3 16.5 3 19.58 3 22 5.42 22 8.5c0 3.78-3.4 6.86-8.55 11.54L12 21.35z"/>
                          </svg>
                          100%
                        </span>
                    </div>
                      
                    {/* Content */}
                      <div className="flex-1 p-5 space-y-4">
                      <div className="text-left">
                          <p className="text-emerald-400 text-sm font-medium">Добрый вечер 🌙</p>
                          <h2 className="text-xl font-bold text-white font-serif">Как вы себя чувствуете?</h2>
                      </div>
                        
                        {/* Mood selector */}
                        <div className="flex justify-between px-2 py-4 glass rounded-2xl">
                          {["😔", "😕", "😐", "🙂", "😊"].map((emoji, i) => (
                            <button
                              key={i}
                              className={`text-2xl p-2 rounded-xl transition ${i === 3 ? "bg-emerald-500/30 scale-110" : "hover:bg-white/5"}`}
                            >
                              {emoji}
                            </button>
                          ))}
                        </div>
                        
                        {/* Today's practice */}
                        <div className="bg-gradient-to-br from-emerald-600/30 to-green-700/20 rounded-2xl p-4 border border-emerald-500/20">
                        <div className="flex items-center gap-3 mb-3">
                            <div className="w-12 h-12 bg-emerald-500/20 rounded-xl flex items-center justify-center text-xl">
                            🧘
                          </div>
                            <div className="flex-1">
                              <p className="font-medium text-white text-sm">Вечернее расслабление</p>
                              <p className="text-emerald-400/80 text-xs">15 мин • Снятие стресса</p>
                          </div>
                            <div className="w-10 h-10 bg-emerald-500 rounded-full flex items-center justify-center">
                              <svg className="w-5 h-5 text-white ml-0.5" viewBox="0 0 24 24" fill="currentColor">
                                <path d="M8 5v14l11-7z" />
                              </svg>
                        </div>
                          </div>
                        </div>
                        
                        {/* Quick actions */}
                      <div className="grid grid-cols-2 gap-3">
                          {[
                            { icon: "💬", label: "AI-чат" },
                            { icon: "📝", label: "Дневник" },
                            { icon: "🌬️", label: "Дыхание" },
                            { icon: "📊", label: "Прогресс" },
                          ].map((item) => (
                            <div key={item.label} className="glass rounded-xl p-3 text-center text-sm">
                              <span className="text-lg">{item.icon}</span>
                              <span className="ml-2 text-white/80">{item.label}</span>
                          </div>
                        ))}
                      </div>
                    </div>
                  </div>
                </div>
              </div>
              </motion.div>
            </div>
          </motion.div>
        </div>
        
        {/* Scroll indicator */}
        <motion.div
          initial={{ opacity: 0 }}
          animate={{ opacity: 1 }}
          transition={{ delay: 1.5 }}
          className="absolute bottom-8 left-1/2 -translate-x-1/2"
        >
          <motion.div
            animate={{ y: [0, 10, 0] }}
            transition={{ duration: 1.5, repeat: Infinity }}
            className="w-6 h-10 border-2 border-emerald-500/30 rounded-full flex justify-center pt-2"
          >
            <div className="w-1.5 h-3 bg-emerald-500/50 rounded-full" />
          </motion.div>
        </motion.div>
      </motion.section>

      {/* Trust Banner */}
      <section className="py-8 border-y border-white/5 glass">
        <div className="max-w-7xl mx-auto px-4">
          <div className="flex flex-wrap justify-center items-center gap-8 md:gap-16 text-white/40">
            <span className="flex items-center gap-2 text-sm">
              <svg className="w-5 h-5 text-emerald-500" viewBox="0 0 24 24" fill="currentColor">
                <path d="M12 1L3 5v6c0 5.55 3.84 10.74 9 12 5.16-1.26 9-6.45 9-12V5l-9-4zm-2 16l-4-4 1.41-1.41L10 14.17l6.59-6.59L18 9l-8 8z"/>
              </svg>
              Данные защищены
            </span>
            <span className="flex items-center gap-2 text-sm">
              <svg className="w-5 h-5 text-emerald-500" viewBox="0 0 24 24" fill="currentColor">
                <path d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm-2 15l-5-5 1.41-1.41L10 14.17l7.59-7.59L19 8l-9 9z"/>
              </svg>
              Научно обоснованные методы
            </span>
            <span className="flex items-center gap-2 text-sm">
              <svg className="w-5 h-5 text-emerald-500" viewBox="0 0 24 24" fill="currentColor">
                <path d="M16 11c1.66 0 2.99-1.34 2.99-3S17.66 5 16 5c-1.66 0-3 1.34-3 3s1.34 3 3 3zm-8 0c1.66 0 2.99-1.34 2.99-3S9.66 5 8 5C6.34 5 5 6.34 5 8s1.34 3 3 3zm0 2c-2.33 0-7 1.17-7 3.5V19h14v-2.5c0-2.33-4.67-3.5-7-3.5z"/>
              </svg>
              Партнёрство с психологами
            </span>
          </div>
        </div>
      </section>

      {/* Stats Section */}
      <section className="py-24">
        <div className="max-w-7xl mx-auto px-4">
          <div className="grid md:grid-cols-4 gap-8 text-center">
            {[
              { value: 500000, suffix: "+", label: "Пользователей" },
              { value: 200, suffix: "+", label: "Практик и медитаций" },
              { value: 89, suffix: "%", label: "Отмечают улучшение" },
              { value: 4.9, suffix: "", label: "Рейтинг в сторах" },
            ].map((stat, i) => (
              <motion.div
                key={i}
                initial={{ opacity: 0, y: 20 }}
                whileInView={{ opacity: 1, y: 0 }}
                transition={{ delay: i * 0.1 }}
                viewport={{ once: true }}
                className="glass rounded-2xl p-8"
              >
                <AnimatedCounter value={stat.value} suffix={stat.suffix} />
                <p className="text-white/50 mt-2">{stat.label}</p>
              </motion.div>
            ))}
          </div>
        </div>
      </section>

      {/* Features Section */}
      <section id="features" className="py-24">
        <div className="max-w-7xl mx-auto px-4">
          <motion.div
            initial={{ opacity: 0, y: 20 }}
            whileInView={{ opacity: 1, y: 0 }}
            viewport={{ once: true }}
            className="text-center mb-16"
          >
            <span className="inline-block px-4 py-1.5 bg-emerald-500/10 text-emerald-400 rounded-full text-sm font-medium mb-4">
              Возможности
              </span>
            <h2 className="text-4xl md:text-5xl font-bold mb-6 font-serif">
              Всё для вашего{" "}
              <span className="gradient-text">ментального благополучия</span>
            </h2>
            <p className="text-xl text-white/50 max-w-2xl mx-auto">
              Научно обоснованные техники самопомощи в удобном формате
            </p>
          </motion.div>

          <div className="grid md:grid-cols-2 lg:grid-cols-3 gap-6">
            {features.map((feature, i) => (
              <FeatureCard key={i} {...feature} />
            ))}
          </div>
        </div>
      </section>

      {/* How it works */}
      <section id="how-it-works" className="py-24 relative">
        <div className="absolute inset-0 bg-gradient-to-b from-emerald-900/10 via-transparent to-transparent" />
        <div className="max-w-7xl mx-auto px-4 relative">
          <motion.div
            initial={{ opacity: 0, y: 20 }}
            whileInView={{ opacity: 1, y: 0 }}
            viewport={{ once: true }}
            className="text-center mb-16"
          >
            <span className="inline-block px-4 py-1.5 bg-emerald-500/10 text-emerald-400 rounded-full text-sm font-medium mb-4">
              Как это работает
            </span>
            <h2 className="text-4xl md:text-5xl font-bold mb-6 font-serif">
              Три шага к лучшему самочувствию
            </h2>
          </motion.div>

          <div className="grid md:grid-cols-3 gap-8">
            {[
              {
                step: "01",
                title: "Скачайте и настройте",
                description: "Ответьте на несколько вопросов, чтобы мы подобрали персональную программу",
                icon: "📱",
              },
              {
                step: "02",
                title: "Практикуйте ежедневно",
                description: "Уделяйте 5-15 минут в день медитациям, дыханию или CBT-упражнениям",
                icon: "🌱",
              },
              {
                step: "03",
                title: "Отслеживайте прогресс",
                description: "Ведите дневник настроения и наблюдайте положительные изменения",
                icon: "📈",
              },
            ].map((item, i) => (
              <motion.div
                key={i}
                initial={{ opacity: 0, y: 20 }}
                whileInView={{ opacity: 1, y: 0 }}
                transition={{ delay: i * 0.2 }}
                viewport={{ once: true }}
                className="relative text-center glass rounded-[2rem] p-8"
              >
                <div className="absolute -top-4 left-1/2 -translate-x-1/2 w-8 h-8 bg-emerald-500 rounded-full flex items-center justify-center text-sm font-bold">
                  {item.step}
                </div>
                <div className="text-6xl mb-6 mt-4">{item.icon}</div>
                <h3 className="text-xl font-semibold text-white mb-3 font-serif">{item.title}</h3>
                <p className="text-white/60">{item.description}</p>
              </motion.div>
            ))}
          </div>
        </div>
      </section>

      {/* AI Companion Section */}
      <section className="py-24">
        <div className="max-w-7xl mx-auto px-4">
          <div className="grid lg:grid-cols-2 gap-16 items-center">
            <motion.div
              initial={{ opacity: 0, x: -30 }}
              whileInView={{ opacity: 1, x: 0 }}
              viewport={{ once: true }}
            >
              <span className="inline-block px-4 py-1.5 bg-emerald-500/10 text-emerald-400 rounded-full text-sm font-medium mb-4">
                AI-собеседник
              </span>
              <h2 className="text-4xl md:text-5xl font-bold mb-6 font-serif">
                Безопасное пространство для{" "}
                <span className="gradient-text">ваших мыслей</span>
              </h2>
              <p className="text-xl text-white/60 mb-8 leading-relaxed">
                AI-собеседник доступен 24/7 и помогает разобраться в эмоциях, 
                структурировать мысли и применять техники самопомощи.
              </p>
              
              <ul className="space-y-4 mb-8">
                {[
                  "Конфиденциальные беседы без осуждения",
                  "Помощь в применении CBT-техник",
                  "Рефлексия и структурирование мыслей",
                  "Доступен в любое время дня и ночи",
                ].map((item, i) => (
                  <li key={i} className="flex items-center gap-3 text-white/80">
                    <span className="text-emerald-400">{Icons.check}</span>
                    {item}
                  </li>
                ))}
              </ul>
              
              <p className="text-sm text-white/40 glass rounded-xl p-4">
                ⚠️ AI-собеседник не заменяет профессиональную психологическую помощь. 
                При серьёзных проблемах обратитесь к специалисту.
              </p>
            </motion.div>
            
            <motion.div
              initial={{ opacity: 0, x: 30 }}
              whileInView={{ opacity: 1, x: 0 }}
              viewport={{ once: true }}
              className="relative"
            >
              <div className="absolute -inset-8 bg-gradient-to-r from-emerald-500/20 to-green-600/10 rounded-[3rem] blur-3xl" />
              <div className="relative glass rounded-[2rem] p-6 space-y-4">
                {/* Chat messages */}
                <div className="flex gap-3">
                  <div className="w-10 h-10 bg-emerald-500/20 rounded-full flex items-center justify-center flex-shrink-0">
                    🤖
                  </div>
                  <div className="glass rounded-2xl rounded-tl-sm p-4 max-w-[80%]">
                    <p className="text-white/80 text-sm">
                      Привет! Как прошёл твой день? Хочешь поделиться тем, что тебя беспокоит?
                    </p>
                  </div>
                </div>
                
                <div className="flex gap-3 justify-end">
                  <div className="bg-emerald-600/30 rounded-2xl rounded-tr-sm p-4 max-w-[80%] border border-emerald-500/20">
                    <p className="text-white/90 text-sm">
                      Сегодня было много стресса на работе. Не могу перестать думать о одном разговоре...
                    </p>
                  </div>
                </div>
                
                <div className="flex gap-3">
                  <div className="w-10 h-10 bg-emerald-500/20 rounded-full flex items-center justify-center flex-shrink-0">
                    🤖
                  </div>
                  <div className="glass rounded-2xl rounded-tl-sm p-4 max-w-[80%]">
                    <p className="text-white/80 text-sm">
                      Понимаю, это бывает непросто. Давай попробуем технику когнитивной переоценки. Какая мысль сейчас крутится у тебя в голове больше всего?
                    </p>
                  </div>
                </div>
                
                <div className="flex gap-2 mt-4">
                  <input
                    type="text"
                    placeholder="Напишите сообщение..."
                    className="flex-1 bg-white/5 border border-white/10 rounded-xl px-4 py-3 text-sm focus:outline-none focus:border-emerald-500/50"
                  />
                  <button className="w-12 h-12 bg-emerald-500 rounded-xl flex items-center justify-center">
                    <svg className="w-5 h-5 text-white" viewBox="0 0 24 24" fill="currentColor">
                      <path d="M2.01 21L23 12 2.01 3 2 10l15 2-15 2z" />
                    </svg>
                  </button>
                </div>
              </div>
            </motion.div>
          </div>
        </div>
      </section>

      {/* Testimonials */}
      <section className="py-24">
        <div className="max-w-7xl mx-auto px-4">
          <motion.div
            initial={{ opacity: 0, y: 20 }}
            whileInView={{ opacity: 1, y: 0 }}
            viewport={{ once: true }}
            className="text-center mb-16"
          >
            <span className="inline-block px-4 py-1.5 bg-emerald-500/10 text-emerald-400 rounded-full text-sm font-medium mb-4">
              Отзывы
              </span>
            <h2 className="text-4xl md:text-5xl font-bold mb-6 font-serif">
              Истории наших{" "}
              <span className="gradient-text">пользователей</span>
            </h2>
            <p className="text-xl text-white/50">Реальные отзывы о том, как MindGarden помогает в повседневной жизни</p>
          </motion.div>

          <TestimonialCarousel />
        </div>
      </section>

      {/* Pricing */}
      <section id="pricing" className="py-24 relative">
        <div className="absolute inset-0 bg-gradient-to-b from-transparent via-emerald-900/10 to-transparent" />
        <div className="max-w-7xl mx-auto px-4 relative">
          <motion.div
            initial={{ opacity: 0, y: 20 }}
            whileInView={{ opacity: 1, y: 0 }}
            viewport={{ once: true }}
            className="text-center mb-16"
          >
            <span className="inline-block px-4 py-1.5 bg-emerald-500/10 text-emerald-400 rounded-full text-sm font-medium mb-4">
              Тарифы
              </span>
            <h2 className="text-4xl md:text-5xl font-bold mb-6 font-serif">
              Начните заботиться о себе{" "}
              <span className="gradient-text">уже сегодня</span>
            </h2>
            <p className="text-xl text-white/50">7 дней бесплатно, затем выберите подходящий план</p>
          </motion.div>

          <div className="grid md:grid-cols-3 gap-8 max-w-5xl mx-auto">
            <PricingCard
              title="Базовый"
              price="249 ₽"
              period="/ месяц"
              description="Для знакомства с практиками"
              features={[
                "50+ медитаций и практик",
                "Базовые дыхательные техники",
                "Трекер настроения",
                "5 сообщений AI в день",
              ]}
              cta="Начать бесплатно"
            />
            <PricingCard
              title="Премиум"
              price="449 ₽"
              period="/ месяц"
              description="Полный доступ ко всем функциям"
              features={[
                "Всё из Базового",
                "200+ практик и курсов",
                "Безлимитный AI-собеседник",
                "CBT-упражнения",
                "Офлайн-доступ",
                "Приоритетная поддержка",
              ]}
              popular
              cta="Попробовать 7 дней"
            />
            <PricingCard
              title="Годовой"
              price="2 990 ₽"
              period="/ год"
              description="Экономия 60% от месячной подписки"
              features={[
                "Всё из Премиум",
                "12 месяцев по цене 6",
                "Эксклюзивные курсы",
                "Ранний доступ к новинкам",
              ]}
              cta="Выбрать годовой"
            />
          </div>
          
          <p className="text-center text-white/40 text-sm mt-8">
            Отмена в любой момент • Никаких скрытых платежей • Возврат в течение 14 дней
          </p>
        </div>
      </section>

      {/* Partnership */}
      <section className="py-24">
        <div className="max-w-4xl mx-auto px-4">
          <motion.div
            initial={{ opacity: 0, scale: 0.95 }}
            whileInView={{ opacity: 1, scale: 1 }}
            viewport={{ once: true }}
            className="glass rounded-[2rem] p-8 md:p-12 text-center relative overflow-hidden"
          >
            <div className="absolute top-0 right-0 w-64 h-64 bg-emerald-500/10 rounded-full blur-3xl" />
            <div className="absolute bottom-0 left-0 w-64 h-64 bg-green-600/10 rounded-full blur-3xl" />
            
            <div className="relative">
              <span className="inline-block px-4 py-1.5 bg-emerald-500/10 text-emerald-400 rounded-full text-sm font-medium mb-4">
                Для специалистов
              </span>
              <h2 className="text-3xl md:text-4xl font-bold mb-4 font-serif">
                Партнёрская программа для психологов
              </h2>
              <p className="text-lg text-white/60 mb-8 max-w-2xl mx-auto">
                Мы сотрудничаем с профессиональными психологами и психотерапевтами. 
                Рекомендуйте MindGarden своим клиентам как дополнение к основной поддержке.
              </p>
              <button className="btn-primary px-8 py-4 rounded-xl font-semibold text-white relative z-10">
                Стать партнёром
              </button>
            </div>
          </motion.div>
        </div>
      </section>

      {/* FAQ */}
      <section id="faq" className="py-24">
        <div className="max-w-3xl mx-auto px-4">
          <motion.div
            initial={{ opacity: 0, y: 20 }}
            whileInView={{ opacity: 1, y: 0 }}
            viewport={{ once: true }}
            className="text-center mb-16"
          >
            <span className="inline-block px-4 py-1.5 bg-emerald-500/10 text-emerald-400 rounded-full text-sm font-medium mb-4">
              FAQ
            </span>
            <h2 className="text-4xl md:text-5xl font-bold font-serif">
              Частые вопросы
            </h2>
          </motion.div>

          <div className="glass rounded-[2rem] p-8">
            {faqs.map((faq, i) => (
              <FAQItem key={i} question={faq.question} answer={faq.answer} />
            ))}
          </div>
        </div>
      </section>

      {/* CTA */}
      <section className="py-24">
        <div className="max-w-4xl mx-auto px-4">
          <motion.div
            initial={{ opacity: 0, scale: 0.95 }}
            whileInView={{ opacity: 1, scale: 1 }}
            viewport={{ once: true }}
            className="relative rounded-[3rem] overflow-hidden"
          >
            <div className="absolute inset-0 bg-gradient-to-br from-emerald-600 to-green-700" />
            <div className="absolute inset-0 leaf-pattern opacity-30" />
            
            <div className="relative p-12 md:p-16 text-center">
              <h2 className="text-4xl md:text-5xl font-bold mb-6 font-serif">
                Начните путь к внутренней гармонии
              </h2>
              <p className="text-xl text-white/80 mb-10 max-w-xl mx-auto">
                Присоединяйтесь к 500 000+ пользователей, которые уже заботятся о своём ментальном благополучии
              </p>
              <div className="flex flex-col sm:flex-row gap-4 justify-center">
                <motion.button
                  whileHover={{ scale: 1.03 }}
                  whileTap={{ scale: 0.98 }}
                  className="flex items-center justify-center gap-3 bg-white text-emerald-700 px-8 py-4 rounded-2xl font-semibold text-lg shadow-xl"
                >
                  {Icons.appStore}
                  App Store
                </motion.button>
                <motion.button
                  whileHover={{ scale: 1.03 }}
                  whileTap={{ scale: 0.98 }}
                  className="flex items-center justify-center gap-3 bg-white/20 backdrop-blur-sm border border-white/30 px-8 py-4 rounded-2xl font-semibold text-lg"
                >
                  {Icons.playStore}
                  Google Play
                </motion.button>
              </div>
            </div>
          </motion.div>
        </div>
      </section>

      {/* Footer */}
      <footer className="py-16 border-t border-white/5">
        <div className="max-w-7xl mx-auto px-4">
          <div className="grid md:grid-cols-4 gap-12 mb-12">
            <div>
              <div className="flex items-center gap-3 mb-4">
                <div className="w-10 h-10 rounded-xl bg-gradient-to-br from-emerald-400 to-green-600 flex items-center justify-center">
                  {Icons.leaf}
            </div>
                <span className="text-xl font-bold text-white font-serif">MindGarden</span>
            </div>
              <p className="text-white/50 text-sm">
                Приложение для заботы о ментальном благополучии. Не является медицинским сервисом.
              </p>
            </div>
            
            <div>
              <h4 className="font-semibold text-white mb-4">Продукт</h4>
              <ul className="space-y-2 text-white/50">
                <li><a href="#features" className="hover:text-emerald-400 transition">Возможности</a></li>
                <li><a href="#pricing" className="hover:text-emerald-400 transition">Тарифы</a></li>
                <li><a href="#" className="hover:text-emerald-400 transition">Скачать</a></li>
              </ul>
            </div>
            
            <div>
              <h4 className="font-semibold text-white mb-4">Поддержка</h4>
              <ul className="space-y-2 text-white/50">
                <li><a href="#faq" className="hover:text-emerald-400 transition">FAQ</a></li>
                <li><a href="#" className="hover:text-emerald-400 transition">Связаться</a></li>
                <li><a href="#" className="hover:text-emerald-400 transition">Для психологов</a></li>
              </ul>
            </div>
            
            <div>
              <h4 className="font-semibold text-white mb-4">Правовая информация</h4>
              <ul className="space-y-2 text-white/50">
                <li><a href="#" className="hover:text-emerald-400 transition">Политика конфиденциальности</a></li>
                <li><a href="#" className="hover:text-emerald-400 transition">Условия использования</a></li>
                <li><a href="#" className="hover:text-emerald-400 transition">Дисклеймер</a></li>
              </ul>
            </div>
          </div>
          
          <div className="flex flex-col md:flex-row justify-between items-center gap-4 pt-8 border-t border-white/5">
            <div className="text-white/30 text-sm">
              © 2024 MindGarden. Все права защищены.
            </div>
            <div className="flex gap-4">
              <a href="#" className="w-10 h-10 glass rounded-full flex items-center justify-center text-white/50 hover:text-emerald-400 transition">
                <svg className="w-5 h-5" fill="currentColor" viewBox="0 0 24 24">
                  <path d="M24 12.073c0-6.627-5.373-12-12-12s-12 5.373-12 12c0 5.99 4.388 10.954 10.125 11.854v-8.385H7.078v-3.47h3.047V9.43c0-3.007 1.792-4.669 4.533-4.669 1.312 0 2.686.235 2.686.235v2.953H15.83c-1.491 0-1.956.925-1.956 1.874v2.25h3.328l-.532 3.47h-2.796v8.385C19.612 23.027 24 18.062 24 12.073z"/>
                </svg>
              </a>
              <a href="#" className="w-10 h-10 glass rounded-full flex items-center justify-center text-white/50 hover:text-emerald-400 transition">
                <svg className="w-5 h-5" fill="currentColor" viewBox="0 0 24 24">
                  <path d="M12 2.163c3.204 0 3.584.012 4.85.07 3.252.148 4.771 1.691 4.919 4.919.058 1.265.069 1.645.069 4.849 0 3.205-.012 3.584-.069 4.849-.149 3.225-1.664 4.771-4.919 4.919-1.266.058-1.644.07-4.85.07-3.204 0-3.584-.012-4.849-.07-3.26-.149-4.771-1.699-4.919-4.92-.058-1.265-.07-1.644-.07-4.849 0-3.204.013-3.583.07-4.849.149-3.227 1.664-4.771 4.919-4.919 1.266-.057 1.645-.069 4.849-.069zm0-2.163c-3.259 0-3.667.014-4.947.072-4.358.2-6.78 2.618-6.98 6.98-.059 1.281-.073 1.689-.073 4.948 0 3.259.014 3.668.072 4.948.2 4.358 2.618 6.78 6.98 6.98 1.281.058 1.689.072 4.948.072 3.259 0 3.668-.014 4.948-.072 4.354-.2 6.782-2.618 6.979-6.98.059-1.28.073-1.689.073-4.948 0-3.259-.014-3.667-.072-4.947-.196-4.354-2.617-6.78-6.979-6.98-1.281-.059-1.69-.073-4.949-.073z"/>
                </svg>
              </a>
              <a href="#" className="w-10 h-10 glass rounded-full flex items-center justify-center text-white/50 hover:text-emerald-400 transition">
                <svg className="w-5 h-5" fill="currentColor" viewBox="0 0 24 24">
                  <path d="M23.953 4.57a10 10 0 01-2.825.775 4.958 4.958 0 002.163-2.723c-.951.555-2.005.959-3.127 1.184a4.92 4.92 0 00-8.384 4.482C7.69 8.095 4.067 6.13 1.64 3.162a4.822 4.822 0 00-.666 2.475c0 1.71.87 3.213 2.188 4.096a4.904 4.904 0 01-2.228-.616v.06a4.923 4.923 0 003.946 4.827 4.996 4.996 0 01-2.212.085 4.936 4.936 0 004.604 3.417 9.867 9.867 0 01-6.102 2.105c-.39 0-.779-.023-1.17-.067a13.995 13.995 0 007.557 2.209c9.053 0 13.998-7.496 13.998-13.985 0-.21 0-.42-.015-.63A9.935 9.935 0 0024 4.59z"/>
                </svg>
              </a>
            </div>
          </div>
        </div>
      </footer>
    </div>
  );
}
