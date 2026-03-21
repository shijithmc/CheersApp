class UserModel {
  final String uid;
  final String name;
  final String phone;
  final int age;
  final String? bloodGroup;
  final String? email;
  final String? location;
  final String? address;
  final String? pincode;
  final int points;
  final String? profileImage;
  final DateTime createdAt;

  UserModel({
    required this.uid,
    required this.name,
    required this.phone,
    required this.age,
    this.bloodGroup,
    this.email,
    this.location,
    this.address,
    this.pincode,
    this.points = 0,
    this.profileImage,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  factory UserModel.fromJson(Map<String, dynamic> j) => UserModel(
        uid: j['uid'] ?? '',
        name: j['name'] ?? '',
        phone: j['phone'] ?? '',
        age: j['age'] ?? 0,
        bloodGroup: j['blood_group'],
        email: j['email'],
        location: j['location'],
        address: j['address'],
        pincode: j['pincode'],
        points: j['points'] ?? 0,
        profileImage: j['profile_image'],
        createdAt: DateTime.tryParse(j['created_at'] ?? '') ?? DateTime.now(),
      );

  Map<String, dynamic> toJson() => {
        'uid': uid,
        'name': name,
        'phone': phone,
        'age': age,
        'blood_group': bloodGroup,
        'email': email,
        'location': location,
        'address': address,
        'pincode': pincode,
        'points': points,
        'profile_image': profileImage,
        'created_at': createdAt.toIso8601String(),
      };
}

class Venue {
  final String id;
  final String name;
  final double rating;
  final String category;
  final String address;
  final String? geoLocation;
  final List<String> images;
  final String phone;
  final String? website;
  final String? description;
  final int starLevel;

  Venue({
    required this.id,
    required this.name,
    required this.rating,
    required this.category,
    required this.address,
    this.geoLocation,
    this.images = const [],
    required this.phone,
    this.website,
    this.description,
    this.starLevel = 3,
  });

  factory Venue.fromJson(Map<String, dynamic> j) => Venue(
        id: j['id'] ?? '',
        name: j['name'] ?? '',
        rating: (j['rating'] ?? 0).toDouble(),
        category: j['category'] ?? '',
        address: j['address'] ?? '',
        geoLocation: j['geo_location'],
        images: List<String>.from(j['images'] ?? []),
        phone: j['phone'] ?? '',
        website: j['website'],
        description: j['description'],
        starLevel: j['star_level'] ?? 3,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'rating': rating,
        'category': category,
        'address': address,
        'geo_location': geoLocation,
        'images': images,
        'phone': phone,
        'website': website,
        'description': description,
        'star_level': starLevel,
      };
}

class Event {
  final String id;
  final String title;
  final String? image;
  final String? venueId;
  final DateTime eventDate;
  final String eventStatus;
  final String? description;
  final String? organizer;

  Event({
    required this.id,
    required this.title,
    this.image,
    this.venueId,
    required this.eventDate,
    this.eventStatus = 'new',
    this.description,
    this.organizer,
  });

  factory Event.fromJson(Map<String, dynamic> j) => Event(
        id: j['id'] ?? '',
        title: j['title'] ?? '',
        image: j['image'],
        venueId: j['venue_id'],
        eventDate: DateTime.tryParse(j['event_date'] ?? '') ?? DateTime.now(),
        eventStatus: j['event_status'] ?? 'new',
        description: j['description'],
        organizer: j['organizer'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'image': image,
        'venue_id': venueId,
        'event_date': eventDate.toIso8601String(),
        'event_status': eventStatus,
        'description': description,
        'organizer': organizer,
      };
}

class Offer {
  final String id;
  final String? venueId;
  final String title;
  final String? description;
  final int discountPercent;
  final DateTime validFrom;
  final DateTime validTo;
  final String? venueName;

  Offer({
    required this.id,
    this.venueId,
    required this.title,
    this.description,
    this.discountPercent = 0,
    required this.validFrom,
    required this.validTo,
    this.venueName,
  });

  factory Offer.fromJson(Map<String, dynamic> j) => Offer(
        id: j['id'] ?? '',
        venueId: j['venue_id'],
        title: j['title'] ?? '',
        description: j['description'],
        discountPercent: j['discount_percent'] ?? 0,
        validFrom: DateTime.tryParse(j['valid_from'] ?? '') ?? DateTime.now(),
        validTo: DateTime.tryParse(j['valid_to'] ?? '') ?? DateTime.now(),
        venueName: j['venue_name'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'venue_id': venueId,
        'title': title,
        'description': description,
        'discount_percent': discountPercent,
        'valid_from': validFrom.toIso8601String(),
        'valid_to': validTo.toIso8601String(),
        'venue_name': venueName,
      };
}

class Job {
  final String id;
  final String title;
  final String companyName;
  final int salaryMin;
  final int salaryMax;
  final String? shift;
  final String? location;
  final String? description;
  final DateTime postedDate;

  Job({
    required this.id,
    required this.title,
    required this.companyName,
    this.salaryMin = 0,
    this.salaryMax = 0,
    this.shift,
    this.location,
    this.description,
    DateTime? postedDate,
  }) : postedDate = postedDate ?? DateTime.now();

  factory Job.fromJson(Map<String, dynamic> j) => Job(
        id: j['id'] ?? '',
        title: j['title'] ?? '',
        companyName: j['company_name'] ?? '',
        salaryMin: j['salary_min'] ?? 0,
        salaryMax: j['salary_max'] ?? 0,
        shift: j['shift'],
        location: j['location'],
        description: j['description'],
        postedDate: DateTime.tryParse(j['posted_date'] ?? '') ?? DateTime.now(),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'company_name': companyName,
        'salary_min': salaryMin,
        'salary_max': salaryMax,
        'shift': shift,
        'location': location,
        'description': description,
        'posted_date': postedDate.toIso8601String(),
      };
}

class AppNotification {
  final String id;
  final String title;
  final String body;
  final String type;
  final String emoji;
  final String bgColor;
  final String timeLabel;
  final DateTime createdAt;
  final bool read;

  AppNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.type,
    this.emoji = '',
    this.bgColor = '',
    this.timeLabel = '',
    DateTime? createdAt,
    this.read = false,
  }) : createdAt = createdAt ?? DateTime.now();

  factory AppNotification.fromJson(Map<String, dynamic> j) => AppNotification(
        id: j['id'] ?? '',
        title: j['title'] ?? '',
        body: j['body'] ?? '',
        type: j['type'] ?? '',
        emoji: j['emoji'] ?? '',
        bgColor: j['bg_color'] ?? '',
        timeLabel: j['time_label'] ?? '',
        createdAt: DateTime.tryParse(j['created_at'] ?? '') ?? DateTime.now(),
        read: j['read'] ?? false,
      );
}

class AppBanner {
  final String id;
  final String title;
  final String subtitle;
  final String emoji;
  final String? image;
  final int sortOrder;

  AppBanner({required this.id, required this.title, required this.subtitle, this.emoji = '', this.image, this.sortOrder = 0});

  factory AppBanner.fromJson(Map<String, dynamic> j) => AppBanner(
        id: j['id'] ?? '',
        title: j['title'] ?? '',
        subtitle: j['subtitle'] ?? '',
        emoji: j['emoji'] ?? '',
        image: j['image'],
        sortOrder: j['sort_order'] ?? 0,
      );
}

class Poster {
  final String id;
  final String venueName;
  final String venueMeta;
  final String? avatarEmoji;
  final String? avatarText;
  final String? tag;
  final String? tagColor;
  final String? topRightLabel;
  final String bgColor1;
  final String bgColor2;
  final double height;
  final String contentTitle;
  final String? contentSubtitle;
  final String? contentEmoji;
  final String? image;
  final String? saveLabel;
  final String? saveColor;
  final String category;
  final int likeCount;
  final int commentCount;
  final int sortOrder;

  Poster({
    required this.id, required this.venueName, this.venueMeta = '', this.avatarEmoji, this.avatarText,
    this.tag, this.tagColor, this.topRightLabel, this.bgColor1 = '', this.bgColor2 = '',
    this.height = 260, this.contentTitle = '', this.contentSubtitle, this.contentEmoji, this.image,
    this.saveLabel, this.saveColor, this.category = '', this.likeCount = 0, this.commentCount = 0, this.sortOrder = 0,
  });

  factory Poster.fromJson(Map<String, dynamic> j) => Poster(
        id: j['id'] ?? '',
        venueName: j['venue_name'] ?? '',
        venueMeta: j['venue_meta'] ?? '',
        avatarEmoji: j['avatar_emoji'],
        avatarText: j['avatar_text'],
        tag: j['tag'],
        tagColor: j['tag_color'],
        topRightLabel: j['top_right_label'],
        bgColor1: j['bg_color1'] ?? '',
        bgColor2: j['bg_color2'] ?? '',
        height: (j['height'] ?? 260).toDouble(),
        contentTitle: j['content_title'] ?? '',
        contentSubtitle: j['content_subtitle'],
        contentEmoji: j['content_emoji'],
        image: j['image'],
        saveLabel: j['save_label'],
        saveColor: j['save_color'],
        category: j['category'] ?? '',
        likeCount: j['like_count'] ?? 0,
        commentCount: j['comment_count'] ?? 0,
        sortOrder: j['sort_order'] ?? 0,
      );
}
