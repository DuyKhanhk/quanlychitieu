// ignore_for_file: non_constant_identifier_names

class CategorySpending {
  int thueNha, hocTap, diLai, anUong, giaiTri, dienNuoc, mangWifi, muaSam, khac;

  CategorySpending(
    this.thueNha,
    this.hocTap,
    this.diLai,
    this.anUong,
    this.giaiTri,
    this.dienNuoc,
    this.mangWifi,
    this.muaSam,
    this.khac,
  );
}

class CategoryIncome {
  int luong,
      thuongLuong,
      kinhDoanh,
      dauTu,
      choThue,
      donate,
      thuNhapThuDong,
      khac;
  CategoryIncome(this.thuongLuong, this.kinhDoanh, this.dauTu, this.choThue,
      this.donate, this.thuNhapThuDong, this.khac, this.luong);
}

class MonthChart {
  double t1, t2, t3, t4, t5, t6, t7, t8, t9, t10, t11, t12;
  MonthChart(this.t1, this.t2, this.t3, this.t4, this.t5, this.t6, this.t7,
      this.t8, this.t9, this.t10, this.t11, this.t12);
}
