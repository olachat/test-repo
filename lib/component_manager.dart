import "package:analyzer/dart/analysis/utilities.dart";
import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/syntactic_entity.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/dart/ast/token.dart';
import 'package:analyzer/dart/element/element.dart';

String str = """
class ComponentManager {
  static ComponentManager _instance;

  static const String MANAGER_BBCORE = 'bbcore'; //bbcore，仅用于资源管理
  static const String MANAGER_MAIN = 'main'; //主app
  static const String MANAGER_SETTINGS = 'settings';
  static const String MANAGER_LOGIN = 'login';
  static const String MANAGER_ORDER = 'order';
  static const String MANAGER_CHAT = 'chat';
  static const String MANAGER_FLEET = 'fleet';
  static const String MANAGER_RANK = 'rank';
  static const String MANAGER_SEARCH = 'search';
  static const String MANAGER_PAY = 'pay';
  static const String MANAGER_CERTIFICATE = 'certificate';
  static const String MANAGER_VIDEO = 'video';
  static const String MANAGER_GROUP = 'group';
  static const String MANAGER_VIP = 'vip';
  static const String MANAGER_BBROOM = 'bbroom';
  static const String MANAGER_CATEGORY_SELECTOR = 'category_selector';
  static const String MANAGER_PERSONALDATA = 'personaldata';
  static const String MANAGER_GIFT = 'gift';
  static const String MANAGER_PREMADE = 'premade';
  static const String MANAGER_RESEARCH = 'research';
  static const String MANAGER_KILLER = 'killer';
  static const String MANAGER_MOMENT = 'moment';
  static const String MANAGER_MUSIC = 'music';
  static const String MANAGER_RUSH = 'rush';
  static const String MANAGER_MESSAGE = 'message';
  static const String MANAGER_PROFILE = 'profile';
  static const String MANAGER_PLATFORM_COPY = 'platform_copy';

  static const String MANAGER_PLATFORM_LINE = 'platform_line';
  static const String MANAGER_PLATFORM_WECHAT = 'platform_wechat';
  static const String MANAGER_PLATFORM_QQ = 'platform_qq';
  static const String MANAGER_PLATFORM_APPLE = 'platform_apple';
  static const String MANAGER_PLATFORM_XIAOMI = 'platform_xiaomi';
  static const String MANAGER_PLATFORM_FACEBOOK = 'platform_facebook';
  static const String MANAGER_PLATFORM_SNAPCHAT = 'platform_snapchat';
  static const String MANAGER_PLATFORM_GOOGLE = 'platform_google';
  static const String MANAGER_PLATFORM_INS = 'platform_ins';
  static const String MANAGER_PLATFORM_TWITTER = 'platform_twitter';
  static const String MANAGER_PLATFORM_WHATSAPP = 'platform_whatsapp';
  static const String MANAGER_PLATFORM_NAVER = 'platform_naver';
  static const String MANAGER_WERE_WOLF = 'were_wolf';

  static const String MANAGER_DRAW_GUESS = 'draw_guess';
  static const String MANAGER_MATCH = 'match'; // 赛事
  static const String MANAGER_TASK = 'task';
  static const String MANAGER_CLOUD_GAME = 'cloud_game';
  static const String MANAGER_MOVIE = 'movie'; // 一起看

  static const String MANAGER_ROOM_ZEGO_GAMES = 'room_zego_games'; // 即构小游戏

  /// --- begin: 游戏中台 ---
  static const String MANAGER_BBGAME_CORE = 'bbgame_core';
  static const String MANAGER_BBGAME_NORMAL = 'bbgame_normal';
  static const String MANAGER_BBGAME_ROOM = 'bbgame_room';
  static const String MANAGER_BBGAME_UNO = 'bbgame_uno';
  /// ---   end: 游戏中台 ---

  /// CP小屋
  static const String MANAGER_CP_HUT = 'cp_hut';

  final Map<String, IResourceLoader> _managers = {};

  ComponentManager._();

  static ComponentManager get instance {
    _instance ??= ComponentManager._();
    return _instance;
  }

  void initResources() {
    _instance._managers.forEach((String name, IResourceLoader manager) {
      if (manager != null) manager.loadStrings();
    });
  }

  void _addManager(String managerName, IResourceLoader managerImpl) {
    _managers[managerName] = managerImpl;
  }

  void _removeManager(String managerName) {
    _managers.remove(managerName);
  }

  dynamic getManager(String managerName) {
    return _managers[managerName];
  }

  void registerManager(String managerName, IResourceLoader manager) {
    if (manager != null) {
      instance._addManager(managerName, manager);
    }
  }

  void unregisterManager(String managerName) {
    instance._removeManager(managerName);
  }

  Map<String, IResourceLoader> getManagers() {
    return _managers;
  }

  void addLocaleModule(String moduleName) {
    _addManager(moduleName, null);
  }
}

""";

class ComponentManagerAst extends GeneralizingAstVisitor {

  final Map<String, String> _fieldNameValueMap = {};
  Map<String, String> get fields => _fieldNameValueMap;

  @override
  visitFieldDeclaration(FieldDeclaration node) {
  if (!node.isStatic) {
    return;
  }
  VariableDeclaration declaration = node.fields.variables.first;
  
  if (declaration.isConst && declaration.name.type == TokenType.IDENTIFIER) {
    
    if (declaration.name.lexeme.startsWith('MANAGER_')) {
    }
    Expression? initializer = declaration.initializer;
    if (initializer is SimpleStringLiteral) {
      _fieldNameValueMap[declaration.name.lexeme] = initializer.value; 
      
    } else {
      throw Exception("Do not interpolate nor compute package names for component manager.");
    }
    
  }
  
    return super.visitFieldDeclaration(node);
  }

}

void main() {
  
  ParseStringResult result = parseString(content: str);
  final visitor = ComponentManagerAst();
  visitor.visitCompilationUnit(result.unit);
  print(visitor.fields);
  print(visitor.fields.length);
  // for (final declaration in result.unit.declarations) {
    
  //   for (final entity in declaration.childEntities) {
  //     if (entity is AstNode) {
  //       recursivePrintEntity(entity);
  //     }
      
      
  //   }
    

  // }

  
}