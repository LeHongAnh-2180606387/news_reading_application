import 'package:news_reading_application/model/category_model.dart';
import 'package:news_reading_application/model/slider_model.dart';

List<SliderModel> getSliders() {
  List<SliderModel> slider = [];
  SliderModel categoryModel = new SliderModel();

  categoryModel.image = "images/business.jpg";
  categoryModel.name = "Bow to the Authority of Silenforce";
  slider.add(categoryModel);
  categoryModel = new SliderModel();

  categoryModel.image = "images/entertainment.jpg";
  categoryModel.name = "Bow to the Authority of Silenforce";
  slider.add(categoryModel);
  categoryModel = new SliderModel();

  categoryModel.image = "images/health.jpg";
  categoryModel.name = "Bow to the Authority of Silenforce";
  slider.add(categoryModel);
  categoryModel = new SliderModel();

  return slider;
}
