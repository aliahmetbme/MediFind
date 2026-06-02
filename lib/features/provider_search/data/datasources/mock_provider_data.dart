// lib/features/provider_search/data/datasources/mock_provider_data.dart
//
// ── Responsibility ────────────────────────────────────────────────────────────
// Provides a static in-memory dataset that simulates the JSON payload a real
// REST / GraphQL API would return.
//
// This file exists *only* to unblock UI and ViewModel development before a
// real back-end is available. Replace [ProviderRemoteDataSource] (or a future
// HTTP datasource) with a real network call; this file then becomes obsolete.
//
// Data format:  Every map in [rawData] is a valid [ProviderModel.fromJson]
// input, meaning it mirrors the exact JSON shape produced by the API contract.
// ─────────────────────────────────────────────────────────────────────────────

/// Static mock dataset simulating an API response for provider search.
///
/// Key design decisions:
///   • Each entry is a plain `Map<String, dynamic>` so [ProviderModel.fromJson]
///     can deserialize it directly — the same path real JSON takes.
///   • All nullable fields (`imageUrl`, `hospital`, `rating`, etc.) are
///     intentionally omitted on some entries to exercise null-safety guards in
///     the UI layer.
///   • Specialty values match the [ProviderSpecialty] `@JsonValue` strings
///     defined in `provider_enums.dart`.
abstract final class MockProviderData {
  static const List<Map<String, dynamic>> rawData = [
    // ── 1. Cardiology ─────────────────────────────────────────────────────────
    {
      'id': 'prov-001',
      'title': 'Dr.',
      'name': 'Julian Thorne',
      'role': 'Senior Interventional Cardiologist',
      'imageUrl':
          'https://images.unsplash.com/photo-1612349317150-e413f6a5b16d?q=80&w=200&auto=format&fit=crop',
      'city': 'New York',
      'hospital': "St. Mary's Medical Center",
      'isBoardCertified': true,
      'rating': 4.8,
      'reviewCount': 312,
      'specialties': ['cardiology'],
      'countries': ['usa'],
      'availableDays': ['Monday', 'Wednesday', 'Friday'],
      'about':
          'Dr. Thorne has over 20 years of experience in interventional cardiology.',
      'contactInfo': {
        'email': 'j.thorne@stmarys.com',
        'phone': {'countryCode': '+1', 'number': '212-555-0100'},
      },
    },

    // ── 2. Dermatology ────────────────────────────────────────────────────────
    {
      'id': 'prov-002',
      'title': 'Dr.',
      'name': 'Isabelle Moreau',
      'role': 'Consultant Dermatologist',
      'imageUrl':
          'https://images.unsplash.com/photo-1594824476967-48c8b964273f?q=80&w=200&auto=format&fit=crop',
      'city': 'Paris',
      'hospital': 'Hôpital Saint-Louis',
      'isBoardCertified': true,
      'rating': 4.6,
      'reviewCount': 187,
      'specialties': ['dermatology'],
      'countries': ['france'],
      'availableDays': ['Tuesday', 'Thursday'],
      'about':
          'Dr. Moreau is a leading expert in inflammatory skin conditions.',
      'contactInfo': {'email': 'i.moreau@hopital-saint-louis.fr'},
    },

    // ── 3. Neurology ──────────────────────────────────────────────────────────
    {
      'id': 'prov-003',
      'title': 'Prof.',
      'name': 'Marcus Steiner',
      'role': 'Neurologist & Epileptologist',
      'imageUrl':
          'https://images.unsplash.com/photo-1537368910025-700350fe46c7?q=80&w=200&auto=format&fit=crop',
      'city': 'Berlin',
      'hospital': 'Charité – Universitätsmedizin',
      'isBoardCertified': true,
      'rating': 4.9,
      'reviewCount': 540,
      'specialties': ['neurology'],
      'countries': ['germany'],
      'availableDays': ['Monday', 'Tuesday', 'Thursday', 'Friday'],
      'about': 'Prof. Steiner leads the epilepsy unit at Charité.',
      'contactInfo': {
        'email': 'm.steiner@charite.de',
        'phone': {'countryCode': '+49', 'number': '30-450-560100'},
      },
    },

    // ── 4. Pediatrics ─────────────────────────────────────────────────────────
    {
      'id': 'prov-004',
      'title': 'Dr.',
      'name': 'Priya Nair',
      'role': 'Pediatric Hospitalist',
      'imageUrl':
          'https://images.unsplash.com/photo-1559839734-2b71ea197ec2?q=80&w=200&auto=format&fit=crop',
      'city': 'Toronto',
      'isBoardCertified': false,
      'rating': 4.5,
      'reviewCount': 98,
      'specialties': ['pediatrics'],
      'countries': ['canada'],
      'availableDays': ['Wednesday', 'Friday', 'Saturday'],
      'about':
          'Dr. Nair provides compassionate pediatric inpatient care, combining '
          'family-centered communication with evidence-based child health protocols.',
      'contactInfo': {
        'phone': {'countryCode': '+1', 'number': '416-555-0199'},
      },
    },

    // ── 5. Psychiatry ─────────────────────────────────────────────────────────
    {
      'id': 'prov-005',
      'title': 'Dr.',
      'name': 'Eleanor Voss',
      'role': 'Consultant Psychiatrist',
      'imageUrl':
          'https://images.unsplash.com/photo-1559839734-2b71ea197ec2?q=80&w=200&auto=format&fit=crop',
      'city': 'Zurich',
      'hospital': 'Psychiatrische Universitätsklinik',
      'isBoardCertified': true,
      // rating / reviewCount intentionally omitted → tests SizedBox.shrink() path
      'specialties': ['psychiatry'],
      'countries': ['switzerland'],
      'availableDays': ['Monday', 'Thursday'],
      'about':
          'Dr. Voss specialises in mood disorders and has developed evidence-based '
          'CBT protocols adopted by clinics across German-speaking Europe.',
      'contactInfo': {'email': 'e.voss@puk.ch'},
    },

    // ── 6. Orthopedics ────────────────────────────────────────────────────────
    {
      'id': 'prov-006',
      'title': 'Assoc. Prof.',
      'name': 'Oliver Hartley',
      'role': 'Orthopaedic Surgeon',
      'imageUrl':
          'https://images.unsplash.com/photo-1622902046580-2b47f47f5471?q=80&w=200&auto=format&fit=crop',
      'city': 'London',
      'hospital': 'Royal National Orthopaedic Hospital',
      'isBoardCertified': true,
      'rating': 4.7,
      'reviewCount': 256,
      'specialties': ['orthopedics'],
      'countries': ['uk'],
      'availableDays': ['Tuesday', 'Wednesday', 'Friday'],
      'about':
          'Mr. Hartley is a sub-specialist in hip and knee reconstruction, '
          'with a special interest in minimally invasive revision arthroplasty.',
      'contactInfo': {
        'email': 'o.hartley@rnoh.nhs.uk',
        'phone': {'countryCode': '+44', 'number': '20-8954-2300'},
      },
    },

    // ── 7. Oncology ───────────────────────────────────────────────────────────
    {
      'id': 'prov-007',
      'title': 'Dr.',
      'name': 'Sophie Laurent',
      'role': 'Medical Oncologist',
      'imageUrl':
          'https://images.unsplash.com/photo-1527613426441-4da17471b66d?q=80&w=200&auto=format&fit=crop',
      'city': 'Lyon',
      'hospital': 'Centre Léon Bérard',
      'isBoardCertified': true,
      'rating': 4.8,
      'reviewCount': 421,
      'specialties': ['oncology'],
      'countries': ['france'],
      'availableDays': ['Monday', 'Tuesday', 'Wednesday'],
      'about':
          'Dr. Laurent leads breast oncology clinical trials at Centre Léon Bérard '
          'and is a pioneer in personalised immuno-oncology therapies.',
      'contactInfo': {'email': 's.laurent@lyon.unicancer.fr'},
    },

    // ── 8. General Physician ──────────────────────────────────────────────────
    {
      'id': 'prov-008',
      'title': 'Dr.',
      'name': 'Thomas Berg',
      'role': 'General Practitioner',
      'imageUrl':
          'https://images.unsplash.com/photo-1651008376811-b90baee60c1f?q=80&w=200&auto=format&fit=crop',
      'city': 'Hamburg',
      // All optional fields present for a complete data-entry test
      'hospital': 'Eppendorf Medical Group',
      'isBoardCertified': false,
      'rating': 4.3,
      'reviewCount': 65,
      'specialties': ['general_physician'],
      'countries': ['germany'],
      'availableDays': ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday'],
      'about':
          'Dr. Berg provides comprehensive primary care and preventive medicine '
          'for patients of all age groups in Hamburg\'s Eppendorf district.',
      'contactInfo': {
        'email': 't.berg@eppendorf-medical.de',
        'phone': {'countryCode': '+49', 'number': '40-555-0220'},
      },
    },
    // ── 9. Cardiology (Birden fazla uzmanlık ve eksik resim testi) ────────────
    {
      'id': 'prov-009',
      'title': 'Dr.',
      'name': 'David Chen',
      'role': 'Non-Invasive Cardiologist',
      // imageUrl kasıtlı olarak null bırakıldı -> İsim baş harfi veya ikon fallback test edilecek
      'city': 'Vancouver',
      'hospital': 'Vancouver General Hospital',
      'isBoardCertified': true,
      'rating': 4.9,
      'reviewCount': 120,
      'specialties': ['cardiology', 'general_physician'],
      'countries': ['canada'],
      'availableDays': ['Tuesday', 'Thursday', 'Friday'],
      'about':
          'Dr. Chen focuses on preventive cardiology, advanced echocardiography, and general internal medicine.',
      'contactInfo': {'email': 'd.chen@vgh.ca'},
    },

    // ── 10. Dermatology (Eksik hastane ve iletişim testi) ─────────────────────
    {
      'id': 'prov-010',
      'title': 'Dr.',
      'name': 'Elena Rossi',
      'role': 'Cosmetic Dermatologist',
      'imageUrl':
          'https://images.unsplash.com/photo-1524504388940-b1c1722653e1?q=80&w=200&auto=format&fit=crop',
      'city': 'Geneva',
      // hospital kasıtlı olarak null -> UI'da "Bağımsız Muayenehane" veya boşluk mantığı test edilecek
      'isBoardCertified': true,
      'rating': 4.7,
      'reviewCount': 340,
      'specialties': ['dermatology'],
      'countries': [
        'switzerland',
      ], // Modelde İtalya yoksa sorun çıkmasın diye İsviçre kullanıldı
      'availableDays': ['Monday', 'Wednesday'],
      'about':
          'Specializes in laser therapy, acne scar revision, and anti-aging treatments.',
      'contactInfo': {
        'phone': {'countryCode': '+41', 'number': '44-123-4567'},
      },
    },

    // ── 11. General Physician (Tam veri seti ile yoğunluk testi) ──────────────
    {
      'id': 'prov-011',
      'title': 'Dr.',
      'name': 'James Wilson',
      'role': 'Family Medicine Physician',
      'imageUrl':
          'https://images.unsplash.com/photo-1612349317150-e413f6a5b16d?q=80&w=200&auto=format&fit=crop',
      'city': 'Boston',
      'hospital': 'Boston Family Clinic',
      'isBoardCertified': true,
      'rating': 4.2,
      'reviewCount': 45,
      'specialties': ['general_physician'],
      'countries': ['usa'],
      'availableDays': ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday'],
      'about':
          'Dr. Wilson provides holistic family care, chronic disease management, and pediatric preventive health check-ups.',
      'contactInfo': {
        'email': 'j.wilson@austinfamily.com',
        'phone': {'countryCode': '+1', 'number': '512-555-0198'},
      },
    },

    // ── 12. Psychiatry (Çoklu uzmanlık ve null rating testi) ──────────────────
    {
      'id': 'prov-012',
      'title': 'Dr.',
      'name': 'Aisha Rahman',
      'role': 'Child & Adolescent Psychiatrist',
      'imageUrl':
          'https://images.unsplash.com/photo-1594824476967-48c8b964273f?q=80&w=200&auto=format&fit=crop',
      'city': 'London',
      'hospital': 'Maudsley Hospital',
      'isBoardCertified': true,
      // rating ve reviewCount null bırakıldı -> SizedBox.shrink() test edilecek
      'specialties': ['psychiatry', 'pediatrics'],
      'countries': ['uk'],
      'availableDays': ['Wednesday', 'Thursday', 'Saturday'],
      'about':
          'Dr. Rahman specializes in neurodevelopmental disorders in children and adolescents, bridging the gap between pediatrics and mental health.',
      'contactInfo': {'email': 'a.rahman@maudsley.nhs.uk'},
    },

    // ── 13. Neurology (Yüksek review count ve profesör unvanı testi) ──────────
    {
      'id': 'prov-013',
      'title': 'Prof.',
      'name': 'Hans Mueller',
      'role': 'Cognitive Neurologist',
      'imageUrl':
          'https://images.unsplash.com/photo-1537368910025-700350fe46c7?q=80&w=200&auto=format&fit=crop',
      'city': 'Munich',
      'hospital': 'Klinikum rechts der Isar',
      'isBoardCertified': true,
      'rating': 4.9,
      'reviewCount': 890,
      'specialties': ['neurology'],
      'countries': ['germany'],
      'availableDays': ['Monday', 'Tuesday'],
      'about':
          'Prof. Mueller is a world-renowned expert in Alzheimer\'s disease and dementia, actively running clinical trials in Munich.',
      'contactInfo': {
        'phone': {'countryCode': '+49', 'number': '89-4140-0'},
      },
    },

    // ── 14. Orthopedics (Hiç iletişim bilgisi yok testi) ──────────────────────
    {
      'id': 'prov-014',
      'title': 'Dr.',
      'name': 'Kemal Yılmaz',
      'role': 'Spine Surgeon',
      'imageUrl':
          'https://images.unsplash.com/photo-1622902046580-2b47f47f5471?q=80&w=200&auto=format&fit=crop',
      'city': 'Istanbul',
      'hospital': 'Memorial Hospital',
      'isBoardCertified': true,
      'rating': 4.8,
      'reviewCount': 210,
      'specialties': ['orthopedics'],
      'countries': ['turkey'],
      'availableDays': ['Monday', 'Wednesday', 'Friday'],
      'about':
          'Op. Dr. Kemal specializes in minimally invasive spine surgery and scoliosis correction.',
      // contactInfo kasıtlı olarak null bırakıldı -> UI'da "İletişim bilgisi bulunamadı" state'i test edilecek
    },
    // ── 15. Pediatrics & Cardiology (USA - Los Angeles) ─────────────────────
    {
      'id': 'prov-015',
      'title': 'Dr.',
      'name': 'Sarah Connor',
      'role': 'Pediatric Cardiologist',
      'imageUrl':
          'https://images.unsplash.com/photo-1594824476967-48c8b964273f?q=80&w=200&auto=format&fit=crop',
      'city': 'Los Angeles',
      'hospital': 'Childrens Hospital LA',
      'isBoardCertified': true,
      'rating': 4.9,
      'reviewCount': 88,
      'specialties': ['cardiology', 'pediatrics'],
      'countries': ['usa'],
      'availableDays': ['Monday', 'Tuesday', 'Thursday'],
      'about':
          'Dr. Sarah Connor specializes in pediatric cardiac health, congenital anomalies and pediatric care in Los Angeles.',
      'contactInfo': {
        'email': 's.connor@chla.org',
        'phone': {'countryCode': '+1', 'number': '213-555-0155'},
      },
    },
    // ── 16. Psychiatry (Turkey - Ankara) ─────────────────────────────────────
    {
      'id': 'prov-016',
      'title': 'Dr.',
      'name': 'Ahmet Yılmaz',
      'role': 'Clinical Psychiatrist',
      'imageUrl':
          'https://images.unsplash.com/photo-1537368910025-700350fe46c7?q=80&w=200&auto=format&fit=crop',
      'city': 'Ankara',
      'hospital': 'Ankara City Hospital',
      'isBoardCertified': true,
      'rating': 4.7,
      'reviewCount': 95,
      'specialties': ['psychiatry'],
      'countries': ['turkey'],
      'availableDays': ['Monday', 'Wednesday', 'Friday'],
      'about':
          'Dr. Ahmet specializes in cognitive behavioral therapy, anxiety disorders, and adolescent psychology.',
      'contactInfo': {
        'email': 'ahmet.yilmaz@ankarahastanesi.gov.tr',
        'phone': {'countryCode': '+90', 'number': '312-555-0166'},
      },
    },
  ];
}
