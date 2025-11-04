require('dotenv').config();
const mongoose = require('mongoose');
const Doctor = require('./models/Doctor');
const Article = require('./models/Article');

const connectDB = async () => {
  try {
    await mongoose.connect(process.env.MONGODB_URI);
    console.log('MongoDB connected');
  } catch (error) {
    console.error('MongoDB connection error:', error);
    process.exit(1);
  }
};

const sampleDoctors = [
  {
    name: 'Dr. Nicolas Muhigi',
    specialization: 'Cardiology',
    hospital: 'King Faisal Hospital',
    rating: 4.5,
    reviewCount: 123,
    yearsExperience: 15,
    patientCount: 100,
    about: 'Dr. Nicolas is a highly experienced cardiologist with over 15 years of practice in the medical field. Committed to providing exceptional patient care.',
    workingHours: 'Mon - Sat (08:30 AM - 5:00 PM)',
    category: 'Specialty',
    communicationMethods: ['Messaging', 'Audio Call', 'Video Call']
  },
  {
    name: 'Dr. Sarah Johnson',
    specialization: 'Pediatry',
    hospital: 'Rwanda Military Hospital',
    rating: 4.7,
    reviewCount: 156,
    yearsExperience: 12,
    patientCount: 150,
    about: 'Specialized in pediatric care with a focus on child development and preventive medicine.',
    workingHours: 'Mon - Fri (09:00 AM - 6:00 PM)',
    category: 'Private'
  },
  {
    name: 'Dr. James Ndayisenga',
    specialization: 'Dentistry',
    hospital: 'Kibagabaga Hospital',
    rating: 4.6,
    reviewCount: 98,
    yearsExperience: 10,
    patientCount: 80,
    about: 'Expert in dental care and cosmetic dentistry procedures.',
    workingHours: 'Mon - Sat (08:00 AM - 4:00 PM)',
    category: 'Public'
  },
  {
    name: 'Dr. Emma Williams',
    specialization: 'Surgery',
    hospital: 'CHUK',
    rating: 4.8,
    reviewCount: 210,
    yearsExperience: 18,
    patientCount: 200,
    about: 'Experienced surgeon specializing in minimally invasive procedures.',
    workingHours: 'Mon - Fri (07:00 AM - 3:00 PM)',
    category: 'Public'
  },
  {
    name: 'Dr. Marie Uwase',
    specialization: 'Gynecology',
    hospital: 'Kigali Medical Center',
    rating: 4.5,
    reviewCount: 145,
    yearsExperience: 14,
    patientCount: 120,
    about: 'Specialized in maternal and reproductive health care.',
    workingHours: 'Mon - Sat (08:30 AM - 5:30 PM)',
    category: 'Private'
  },
  {
    name: 'Dr. Robert Mukasa',
    specialization: 'Mental Health',
    hospital: 'Ndera Neuropsychiatric Hospital',
    rating: 4.6,
    reviewCount: 87,
    yearsExperience: 11,
    patientCount: 90,
    about: 'Expert psychiatrist focusing on anxiety, depression, and trauma therapy.',
    workingHours: 'Mon - Fri (10:00 AM - 6:00 PM)',
    category: 'Specialty'
  }
];

const sampleArticles = [
  {
    title: '10 tips to boost your immunity systems...',
    subtitle: 'Proven Strategies to Strengthen Your Body\'s Defences & Stay Healthy',
    content: 'The immune system is your body\'s defense mechanism against illness and infection. Maintaining a strong immune system is crucial for overall health. Here are 10 proven tips: 1) Get adequate sleep, 2) Exercise regularly, 3) Eat a balanced diet rich in fruits and vegetables, 4) Stay hydrated, 5) Manage stress levels, 6) Maintain a healthy weight, 7) Don\'t smoke, 8) Limit alcohol consumption, 9) Practice good hygiene, 10) Get vaccinated. Following these guidelines can significantly improve your immune response.',
    author: 'Kyagulanyi Robert',
    publishedDate: new Date('2025-01-15')
  },
  {
    title: 'Eat healthy, live out your best moments...',
    subtitle: 'The food you eat plays a key role in living a vibrant and fulfilling life',
    content: 'Nutrition is fundamental to health and wellbeing. A balanced diet provides the energy and nutrients your body needs to function properly. Focus on whole grains, lean proteins, fruits, vegetables, and healthy fats. Limit processed foods, excessive sugar, and unhealthy fats. Eating mindfully and maintaining portion control are also important. Remember, small dietary changes can lead to significant health improvements over time.',
    author: 'Dr. Sarah Johnson',
    publishedDate: new Date('2025-01-20')
  },
  {
    title: 'Practice the ethics to get you started...',
    subtitle: 'Essential medical ethics every patient should know',
    content: 'Medical ethics form the foundation of healthcare practice. Understanding these principles helps patients make informed decisions about their care. Key principles include: autonomy (respecting patient choices), beneficence (acting in patient\'s best interest), non-maleficence (do no harm), and justice (fair distribution of resources). Patients have the right to informed consent, confidentiality, and to refuse treatment.',
    author: 'Dr. James Ndayisenga',
    publishedDate: new Date('2025-01-25')
  },
  {
    title: 'Under the best uses to healthy living...',
    subtitle: 'Comprehensive guide to maintaining optimal health',
    content: 'Living a healthy lifestyle involves multiple factors working together. Regular physical activity, balanced nutrition, adequate sleep, stress management, and social connections all contribute to wellbeing. It\'s important to find a sustainable routine that works for you. Small, consistent changes often lead to better long-term results than drastic measures. Remember to schedule regular health checkups and screenings.',
    author: 'Dr. Emma Williams',
    publishedDate: new Date('2025-02-01')
  }
];

const seedDatabase = async () => {
  try {
    await connectDB();
    
    // Clear existing data
    await Doctor.deleteMany({});
    await Article.deleteMany({});
    
    console.log('Cleared existing data');
    
    // Insert sample data
    await Doctor.insertMany(sampleDoctors);
    console.log('✅ Doctors seeded successfully');
    
    await Article.insertMany(sampleArticles);
    console.log('✅ Articles seeded successfully');
    
    console.log('🎉 Database seeded successfully!');
    process.exit(0);
  } catch (error) {
    console.error('Error seeding database:', error);
    process.exit(1);
  }
};

seedDatabase();