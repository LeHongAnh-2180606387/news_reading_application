import 'package:news_reading_application/models/category_model.dart';

// List<CategoryModel> getCategories() {
//   List<CategoryModel> category = [];
//   CategoryModel categoryModel = new CategoryModel();

//   categoryModel.categoryName = "Business";
//   categoryModel.image = "images/business.jpg";
//   category.add(categoryModel);
//   categoryModel = new CategoryModel();

//   categoryModel.categoryName = "Entertainment";
//   categoryModel.image = "images/entertainment.jpg";
//   category.add(categoryModel);
//   categoryModel = new CategoryModel();

//   categoryModel.categoryName = "General";
//   categoryModel.image = "images/general.jpg";
//   category.add(categoryModel);
//   categoryModel = new CategoryModel();

//   categoryModel.categoryName = "Health";
//   categoryModel.image = "images/health.jpg";
//   category.add(categoryModel);
//   categoryModel = new CategoryModel();

//   categoryModel.categoryName = "Sports";
//   categoryModel.image = "images/sport.jpg";
//   category.add(categoryModel);
//   categoryModel = new CategoryModel();

//   return category;

List<CategoryModel> getCategories() {
  List<CategoryModel> category = [];

  // Sử dụng constructor để tạo đối tượng với tham số bắt buộc
  category.add(
      CategoryModel(categoryName: "Business", image: "images/business.jpg"));
  category.add(CategoryModel(
      categoryName: "Entertainment", image: "images/entertainment.jpg"));
  category
      .add(CategoryModel(categoryName: "General", image: "images/general.jpg"));
  category
      .add(CategoryModel(categoryName: "Health", image: "images/health.jpg"));
  category
      .add(CategoryModel(categoryName: "Sports", image: "images/sport.jpg"));

  return category;
}
