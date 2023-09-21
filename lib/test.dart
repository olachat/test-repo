
import "package:analyzer/dart/analysis/utilities.dart";
import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/syntactic_entity.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/dart/element/element.dart';

String str = """

class R {
  static Widget img(String path,
      {String package,
      double width,
      double height,
      Color color,
      BoxFit fit,
      Key key,
      bool wholePath = false,
      int cachedWidth,
      int cachedHeight,
      AlignmentGeometry alignment = Alignment.center,
      bool matchTextDirection = false,
      bool isFile = false,
      double scale = 1.0,
      Rect centerSlice,
      bool disableCached = false,
      bool isUsingRepaintBoundaryForWebp = true}) {
        return Container();
      }
}

void test() {
  R.img('rich_charge/ic_left_coin.png',width: 77,fit: BoxFit.fitWidth,package: ComponentManager.MANAGER_BBCORE, 
  isLocal: true);
}

// void testBoolean() {
//   bool test = false;
//   R.img('rich_charge/ic_left_coin.png',width: 77,fit: BoxFit.fitWidth,package: ComponentManager.MANAGER_BBCORE, 
//   isLocal: test);
// }

// void testInterpolation() {
//   bool test = false;
//   R.img('rich_charge/\${test}ic_left_coin.png',width: 77,fit: BoxFit.fitWidth,package: ComponentManager.MANAGER_BBCORE, 
//   isLocal: test);
// }




""";



class MySimpleAstVisitor extends GeneralizingAstVisitor {
  final Map<String, List<String>> _packageFilePathMap = {};
  final Map<String, bool> _imagePathLocalMap = {};
  @override
  visitMethodInvocation(MethodInvocation node) {
    if (node.methodName.name == 'img') {
      Expression? target = node.target;
      if (target != null && target is SimpleIdentifier) {
        if (target.name == "R") {
          NodeList<Expression> args = node.argumentList.arguments;
          String? filename;

          args.forEach((element) {
            
            if (element is SimpleStringLiteral) {
              filename = element.value;
            } else if (element is StringInterpolation) {
              throw Exception("File name is String interpolation: $element");
              
            }
            if (filename == null) {
              // Invalid value as there shouldnt be any named expression before the file name appears.
              return;
            }
            if (element is NamedExpression) {
              
              Label label = element.name;
              if (label.label.name == 'package') {
                Expression value = element.expression;
                if (value is PrefixedIdentifier) {
                  if (_packageFilePathMap[value.name] == null) {
                    _packageFilePathMap[value.name] = [filename!];
                  } else {
                    _packageFilePathMap[value.name]!.add(filename!);
                  }
                  
                  
                } else {
                  throw Exception("isLocal argument for file name '$filename' is not a literal boolean.");
                }
              }

              if (label.label.name == 'isLocal') {
                Expression value = element.expression;
                if (value is BooleanLiteral) {
                  _imagePathLocalMap[filename!] = value.value;
                  
                } else {
                  throw Exception("isLocal argument for file name '$filename' is not a literal boolean.");
                }
              }
              
            }
           });
          
        }
        
      }
    }
    

  }

  // Add more visit methods for the types of nodes you're interested in...
}


void main() {
  ParseStringResult result = parseString(content: str);
  final visitor = MySimpleAstVisitor();
  visitor.visitCompilationUnit(result.unit);
  print(visitor._imagePathLocalMap);
  print(visitor._packageFilePathMap);
  
  
}

