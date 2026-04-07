class AppLocalizations {
  static String language = 'English';
  
  static final Map<String, String> _hi = {
    'Settings': 'सेटिंग्स',
    'General': 'सामान्य',
    'Push Notifications': 'पुश सूचनाएँ',
    'Dark Mode': 'डार्क मोड',
    'App Language': 'ऐप की भाषा',
    'Support': 'सहायता',
    'Help Center': 'सहायता केंद्र',
    'Privacy Policy': 'गोपनीयता नीति',
    'Terms of Service': 'सेवा की शर्तें',
    'Feedback': 'प्रतिक्रिया',
    'Got any suggestions?': 'कोई सुझाव है?',
    'Submit Feedback': 'प्रतिक्रिया भेजें',
    'LOGOUT': 'लॉग आउट',
    'Logout': 'लॉग आउट',
    'Are you sure you want to log out of your account?': 'क्या आप वाकई अपने खाते से लॉग आउट करना चाहते हैं?',
    'Cancel': 'रद्द करें',
    'Feedback submitted successfully! Thank you.': 'प्रतिक्रिया सफलतापूर्वक सबमिट की गई! धन्यवाद।',
    'Feedback cannot be empty': 'प्रतिक्रिया खाली नहीं हो सकती',
    'English': 'अंग्रेज़ी',
    'Hindi': 'हिन्दी',
  };

  static String t(String text) {
    if (language == 'Hindi') {
      return _hi[text] ?? text;
    }
    return text;
  }
}
