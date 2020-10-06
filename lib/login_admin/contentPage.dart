import 'package:recipe_app/pages/admin/show_recipes.dart';
import 'package:recipe_app/pages/admin/MenuPage.dart';
import 'package:recipe_app/pages/myrecipes/list_my_recipe.dart';
import 'package:recipe_app/widgets/home_page.dart';

abstract class Content {


  Future<HomePageRecipes> lista();
  Future<ListMyRecipe> myrecipe(String id);
  Future<MyHomePage> menu();
  Future<InicioPage> admin();

}


class ContentPage implements Content {

  Future<HomePageRecipes> lista() async {
    return HomePageRecipes();
  }

  Future<MyHomePage> menu() async {
    return MyHomePage();
  }
  Future<InicioPage> admin() async {
    return InicioPage();
  }

  Future<ListMyRecipe> myrecipe(String id ) async {
    print('listed my recipes $id');
    return ListMyRecipe(id: id,);
  }

}
