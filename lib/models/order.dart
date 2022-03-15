class Order {
    String carttMtgerId;
    String carttMtgerName;
    String carttMtgerPhoto;
    int   carttMtgerRate;
    String carttNumber;
    String carttFatora;
    String carttSeller;
    String carttDate;
    String carttState;
    String carttStateNumber;
    String carttTotal;
    String carttTawsilDate;
    String carttTawsilTime;
    String carttLocation;
    String carttDeliveryType;
    String carttNotes;
    String deliveryPrice;
    String fromTime;
    String toTime;

    String carttDriver;
    String driverName;
    String driverEmail;
    String driverPhone;
    String driverMapx;
    String driverMapy;
    String driverPhoto;

    List<CarttDetail> carttDetails;

    Order({
        this.carttMtgerId,
        this.carttMtgerName,
        this.carttMtgerPhoto,
        this.carttMtgerRate,
        this.carttNumber,
        this.carttFatora,
        this.carttSeller,
        this.carttDate,
        this.carttState,
        this.carttStateNumber,
        this.carttTotal,
        this.carttTawsilDate,
        this.carttTawsilTime,
        this.carttLocation,
        this.carttDeliveryType,
        this.carttNotes,
        this.deliveryPrice,
        this.fromTime,
        this.toTime,

        this.carttDriver,
        this.driverName,
        this.driverEmail,
        this.driverPhone,
        this.driverMapx,
        this.driverMapy,
        this.driverPhoto,

        this.carttDetails,
    });

    factory Order.fromJson(Map<String, dynamic> json) => Order(
        carttMtgerId: json["cartt_mtger_id"],
        carttMtgerName: json["cartt_mtger_name"],
        carttMtgerPhoto: json["cartt_mtger_photo"],
        carttMtgerRate: json["cartt_mtger_rate"],
        carttNumber: json["cartt_number"],
        carttFatora: json["cartt_fatora"],
        carttSeller: json["cartt_seller"],
        carttDate: json["cartt_date"],
        carttState: json["cartt_state"],
        carttStateNumber: json["cartt_state_number"],
        carttTotal: json["cartt_totlal"],
        carttTawsilDate: json["cartt_tawsil_date"],
        carttTawsilTime: json["cartt_tawsil_time"],
        carttLocation: json["cartt_location"],
        carttDeliveryType: json["cartt_delivery_type"],
        carttNotes: json["cartt_notes"],
        deliveryPrice: json["delivery_price"],
        fromTime: json["from_time"],
        toTime: json["to_time"],

        carttDriver: json["cartt_driver"],
        driverName: json["driver_name"],
        driverEmail: json["driver_email"],
        driverPhone: json["driver_phone"],
        driverMapx: json["driver_mapx"],
        driverMapy: json["driver_mapy"],
        driverPhoto: json["driver_photo"],

        carttDetails: List<CarttDetail>.from(json["cartt_details"].map((x) => CarttDetail.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "cartt_mtger_id": carttMtgerId,
        "cartt_mtger_name": carttMtgerName,
        "cartt_mtger_photo": carttMtgerPhoto,
        "cartt_mtger_rate": carttMtgerRate,
        "cartt_number": carttNumber,
        "cartt_fatora": carttFatora,
        "cartt_seller": carttSeller,
        "cartt_date": carttDate,
        "cartt_state": carttState,
        "cartt_state_number": carttStateNumber,
        "cartt_totlal": carttTotal,
        "cartt_tawsil_date": carttTawsilDate,
        "cartt_tawsil_time": carttTawsilTime,
        "cartt_location": carttLocation,
        "cartt_delivery_type": carttDeliveryType,
        "cartt_notes": carttNotes,
        "delivery_price": deliveryPrice,
        "from_time": fromTime,
        "to_time": toTime,

        "cartt_driver": carttDriver,
        "driver_name": driverName,
        "driver_email": driverEmail,
        "driver_phone": driverPhone,
        "driver_mapx": driverMapx,
        "driver_mapy": driverMapy,
        "driver_photo": driverPhoto,

        "cartt_details": List<dynamic>.from(carttDetails.map((x) => x.toJson())),
    };
}

class CarttDetail {
    String carttName;
    int carttAmount;
    String carttPrice;
    int carttAds;
    String carttPhoto;

    CarttDetail({
        this.carttName,
        this.carttAmount,
        this.carttPrice,
        this.carttPhoto,
        this.carttAds
    });

    factory CarttDetail.fromJson(Map<String, dynamic> json) => CarttDetail(
        carttName: json["cartt_name"],
        carttAmount: json["cartt_amount"],
        carttPrice: json["cartt_price"],
        carttPhoto: json["cartt_photo"],
        carttAds:json["cartt_ads"]
    );

    Map<String, dynamic> toJson() => {
        "cartt_name": carttName,
        "cartt_amount": carttAmount,
        "cartt_price": carttPrice,
        "cartt_photo" :carttPhoto,
        "cartt_ads":carttAds
    };
}
