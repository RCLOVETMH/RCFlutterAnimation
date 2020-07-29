import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rc_animation_demo/newpage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(title: Text("Flutter动画"),),
        body: Demo10()
      ),
    );
  }
}
class Demo1 extends StatefulWidget {
  @override
  _Demo1State createState() => _Demo1State();
}
class _Demo1State extends State<Demo1> with SingleTickerProviderStateMixin{
  AnimationController _controller;
  Animation _animation ;
  @override
  void initState() {
    super.initState();
    // AnimationController继承于Animation，可以调用addListener
    _controller = AnimationController(vsync: this,duration: Duration(seconds: 1))..addListener(() {
      setState(() {});
    })..addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _controller.reverse();
      } else if (status == AnimationStatus.dismissed) {
        _controller.forward();
      }
    });
    // Interval : begin 参数 代表 延迟多长时间开始 动画  end 参数 代表 超过多少 直接就是 100% 即直接到动画终点
    _animation = Tween(begin: 1.0,end: 0.0).animate(CurvedAnimation(parent: _controller,curve: Interval(0.0,0.5,curve: Curves.linear)));
    // _animation有不同的构建方式
    // _animation = Tween(begin: 1.0,end: 0.2).chain(CurveTween(curve: Curves.easeIn)).animate(_controller);
    //  _animation = _controller.drive(Tween(begin: 1.0,end: 0.1)).drive(CurveTween(curve: Curves.linearToEaseOut));
  }
  @override
  Widget build(BuildContext context) { // 动画期间会不停调用build方法
    return InkWell(
      onTap: () => _controller.forward(),
      child: Opacity(
        opacity: _animation.value,
        child: Container(
          width: 100,height: 100, color: Colors.greenAccent,
          child: Center(child: Text("Demo1"),),
        ),
      ),
    );
  }
  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }
}

class Demo2 extends StatefulWidget {
  @override
  _Demo2State createState() => _Demo2State();
}

class _Demo2State extends State<Demo2> with SingleTickerProviderStateMixin{

  AnimationController _controller;
  Color _color = Colors.red;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this,duration: Duration(seconds: 1))
      ..addListener(() {
        setState(() {
           _color = Color.lerp(Colors.red, Colors.green, _controller.value);
        });
      })..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _controller.reverse();
        } else if (status == AnimationStatus.dismissed) {
          _controller.forward();
        }
      });
  }
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        _controller.forward();
      },
      child: Container(
        height: 100,width: 100,
        color: _color,
        child: Center(child: Text("Demo2"),),
      ),
    );
  }
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class Demo3 extends StatefulWidget {
  @override
  _Demo3State createState() => _Demo3State();
}

class _Demo3State extends State<Demo3> with SingleTickerProviderStateMixin{
  double _size = 100;
  AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this,duration: Duration(seconds: 1),lowerBound: 100,upperBound: 200)
      ..addListener(() {
        setState(() {
          _size = _controller.value;
        });
      })..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _controller.reverse();
        } else if (status == AnimationStatus.dismissed) {
          _controller.forward();
        }
      });
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        _controller.forward();
      },
      child: Container(
        width: _size,height: _size,
        color: Colors.redAccent,
        child: Center(child: Text("Demo3"),),
      ),
    );
  }
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class ColorTweenDemo extends StatefulWidget {
  @override
  _ColorTweenDemoState createState() => _ColorTweenDemoState();
}

class _ColorTweenDemoState extends State<ColorTweenDemo> with SingleTickerProviderStateMixin{
  AnimationController _controller;
  Animation <Color> _animation;

  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this,duration: Duration(seconds: 1))
      ..addListener(() {
        setState(() { });
      });
    _animation = ColorTween(begin: Colors.red,end: Colors.green).animate(_controller);
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        _controller.forward();
      },
      child: Container(
        height: 100,width: 100,
        color: _animation.value,
      ),
    );
  }
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class Demo4 extends StatefulWidget {
  @override
  _Demo4State createState() => _Demo4State();
}
class _Demo4State extends State<Demo4> with TickerProviderStateMixin{

  // 可以每个动画都创建各自的AnimationController来控制和监听不同的状态
  AnimationController _controller;

  Animation <double> _sizeAnimation;
  Animation <BorderRadius> _radiusAnimation;
  Animation <Color> _colorAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(vsync: this,duration: Duration(seconds: 1))..addListener(() {
      setState(() {});
    })..addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _controller.reverse();
      } else if (status == AnimationStatus.dismissed) {
        _controller.forward();
      }
    });
    _sizeAnimation = Tween(begin: 100.0,end: 200.0).chain(CurveTween(curve: Curves.linear)).animate(_controller);
    _radiusAnimation = BorderRadiusTween(begin: BorderRadius.zero,end: BorderRadius.circular(100)).animate(_controller);
    _colorAnimation = ColorTween(begin: Colors.redAccent,end: Colors.yellowAccent).chain(CurveTween(curve: Curves.linear)).animate(_controller);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Center(
        child: InkWell(
          onTap: (){
            _controller.forward();
          },
          child: Container(
            width: _sizeAnimation.value,height: _sizeAnimation.value,
            decoration: BoxDecoration(
              border: Border.all(width: 5,color: Colors.greenAccent),
              color: _colorAnimation.value,
              borderRadius: _radiusAnimation.value
            ),
            child: Center(child: Text("Demo4"),),
          ),
        )
      )
    );
  }
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class Demo5 extends StatefulWidget {
  @override
  _Demo5State createState() => _Demo5State();
}

class _Demo5State extends State<Demo5> with SingleTickerProviderStateMixin{
  AnimationController _controller;
  Animation <EdgeInsets>_animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this,duration: Duration(seconds: 2))..addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _controller.reverse();
      } else if (status == AnimationStatus.dismissed) {
        _controller.forward();
      }
    });
    _animation = _controller.drive(EdgeInsetsTween(begin: EdgeInsets.fromLTRB(50, 50, 0, 0),end: EdgeInsets.only(top: 200,left: 200)));
  }

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(seconds: 1),(){
      _controller.forward();
    });
    return EdgeInsetsDemo(animation: _animation,);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
// 使用AnimatedWidget分离
class EdgeInsetsDemo extends AnimatedWidget{

  EdgeInsetsDemo({Key key,Animation<EdgeInsets> animation}):super(key:key,listenable :animation);

  @override
  Widget build(BuildContext context) {
    final Animation<EdgeInsets> animation = listenable;
    return Container(
      margin: animation.value,
      width: 100,
      height: 100,
      color: Colors.redAccent,
    );
  }
}

class Demo6 extends StatefulWidget {
  @override
  _Demo6State createState() => _Demo6State();
}

class _Demo6State extends State<Demo6> with SingleTickerProviderStateMixin{
  AnimationController _controller;
  Animation <Matrix4> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this,duration: Duration(seconds: 2))..addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _controller.reverse();
      } else if (status == AnimationStatus.dismissed) {
        _controller.forward();
      }
    })..addListener(() {
      setState(() {
      });
    });
    _animation = Matrix4Tween(begin: Matrix4.identity()..rotateX(0.0),end: Matrix4.identity()..rotateX(pi)).animate(_controller);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: InkWell(
        onTap: (){
          _controller.forward();
        },
        child: AnimatedBuilderDemo(animation: _animation,)
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
// 使用AnimatedBuilder重构
class AnimatedBuilderDemo extends AnimatedWidget{

  AnimatedBuilderDemo({Key key,Animation<Matrix4> animation}):super(key :key,listenable:animation);

  @override
  Widget build(BuildContext context) {
    final Animation animation = listenable;
    return AnimatedBuilder(
      animation: animation,
      child: Image.asset("assets/g.jpg",),
      builder: (BuildContext context,Widget child){
        return  Container(
          width: 200,height: 200,
          transform: animation.value,
          child: child,
        );
      },
    );
  }
}

class Demo7 extends StatefulWidget {
  @override
  _Demo7State createState() => _Demo7State();
}
class _Demo7State extends State<Demo7> {

  Duration _duration = Duration(seconds: 1);
  bool _animation = false;

  @override
  Widget build(BuildContext context) {

    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Spacer(flex: 2,),
          AnimatedContainer(
            curve: Curves.linear,
            duration: _duration,
            width: _animation ? 200 : 100,height: _animation ? 200 : 100,
            decoration: BoxDecoration(
              borderRadius: _animation ? BorderRadius.circular(100) : BorderRadius.zero,
              color: _animation ? Colors.yellowAccent : Colors.redAccent,
              border: Border.all(width: 5,color: _animation ? Colors.greenAccent : Colors.black87)
            ),
            onEnd: (){ // 动画结束的回调
              setState(() => _animation = !_animation );
            },
            child: InkWell(
              onTap: (){
                setState(() => _animation = !_animation );
              },
            ),
          ),
          Spacer(),
          AnimatedContainer(
            alignment: Alignment.center,
            duration: _duration,
            width: _animation ? 200 : 150,height: _animation ? 100 : 80,
            decoration: BoxDecoration(
              color: Colors.greenAccent,
              borderRadius: _animation == false ? BorderRadius.circular(40) : BorderRadius.zero,
            ),

            child: AnimatedDefaultTextStyle(
              duration: _duration,
              child: Text("Hello world"),
              style: _animation ? TextStyle(color: Colors.black87,fontSize: 12,fontWeight: FontWeight.w100) : TextStyle(color: Colors.redAccent,fontSize: 20,fontWeight: FontWeight.w800),
            ),

          ),
          Spacer(),
          // AnimatedCrossFade 2个组件在切换时出现交叉渐入的效果，需要设置动画前、动画后2个子控件即可。
          AnimatedCrossFade(
            duration: _duration,
            crossFadeState: _animation ? CrossFadeState.showSecond : CrossFadeState.showFirst,
            firstChild: Container(
              alignment: Alignment.center,
              width: 100,height: 120,
              color: Colors.redAccent,
              child: Text("第一个",style: TextStyle(color: Colors.greenAccent),),
            ),
            secondChild: Container(
              alignment: Alignment.center,
              width: 100,height: 100,
              decoration: BoxDecoration(
                  color: Colors.greenAccent,
                  borderRadius: BorderRadius.circular(50)
              ),
              child: Text("第二个",style: TextStyle(color: Colors.redAccent)),
            ),
          ),
          Spacer(flex: 2,)
        ],
      ),
    );
  }
}

class Demo7_1 extends StatefulWidget {
  @override
  _Demo7_1State createState() => _Demo7_1State();
}

class _Demo7_1State extends State<Demo7_1> {
  bool _animation = false;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedOpacity(
        duration: Duration(seconds: 1),
        opacity: _animation ? 0.0 : 1.0,
        onEnd: (){
          setState(() => _animation = !_animation );
        },
        child: Container(
          width: 100,height: 100,
          color: Colors.redAccent,
          child: InkWell(
            onTap: (){
              setState(() => _animation = !_animation );
            },
          ),
        ),
      ),
    );
  }
}


class Demo8 extends StatefulWidget {
  @override
  _Demo8State createState() => _Demo8State();
}

class _Demo8State extends State<Demo8> with SingleTickerProviderStateMixin{
  bool _animation = false;

  AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: Duration(seconds: 1),vsync: this,)
      ..addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _controller.reverse();
      } else if (status == AnimationStatus.dismissed) {
        _controller.forward();
      };
    });
  }

  @override
  Widget build(BuildContext context) {
    return GridView(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
      ),
      children: <Widget>[
        setIcon(AnimatedIcons.play_pause),
        setIcon(AnimatedIcons.add_event),
        setIcon(AnimatedIcons.arrow_menu),
        setIcon(AnimatedIcons.close_menu),
        setIcon(AnimatedIcons.ellipsis_search),
        setIcon(AnimatedIcons.event_add),
        setIcon(AnimatedIcons.home_menu),
        setIcon(AnimatedIcons.list_view),
        InkWell(onTap: () => _controller.forward())
      ],
    );
  }
  Widget setIcon (AnimatedIconData iconData) {
    return Center(
      child: AnimatedIcon(
        size: 30,
        icon: iconData,
        progress: _controller,
      ),
    );
  }
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}


class Demo9 extends StatefulWidget {
  @override
  _Demo9State createState() => _Demo9State();
}

class _Demo9State extends State<Demo9> {
  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: (){
        Navigator.push(context,
          RCFadeRoute(builder: (context){
            return NewPage();
          }),
        );
      },
      child: Container(
        alignment: Alignment.center,
        width: double.infinity,height: double.infinity,
        child: Text("点击进入下一页",style: TextStyle(color: Colors.black,fontSize: 30),),
      ),
    );
  }
}

class RCFadeRoute extends PageRoute{

  final WidgetBuilder builder;

  @override
  final Duration transitionDuration;

  @override
  final bool opaque;

  @override
  final bool barrierDismissible;

  @override
  final Color barrierColor;

  @override
  final String barrierLabel;

  @override
  final bool maintainState;

  RCFadeRoute({
    @required this.builder,
    this.transitionDuration = const Duration(milliseconds: 250),
    this.opaque = true,
    this.barrierDismissible = false,
    this.barrierColor,
    this.barrierLabel,
    this.maintainState = true
  });

  @override
  Widget buildPage(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation)  => builder(context);

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
    return FadeTransition(
      opacity: animation,
      child: builder(context),
    );
  }
}

class Demo10 extends StatefulWidget {
  @override
  _Demo10State createState() => _Demo10State();
}

class _Demo10State extends State<Demo10> {
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: EdgeInsets.only(top: 10,left: 10,right: 10),
      itemCount: 15,
      itemBuilder: (BuildContext content,int index){
        return Container(
          child: InkWell(
            child: Hero(
              tag: "assets/g.jpg"+"$index", // 唯一的标记，前后两个路由的Hero的tag必须相同
              child: Image.asset("assets/g.jpg",fit: BoxFit.cover,),
            ),
            onTap: (){
              Navigator.push(
                context,
                PageRouteBuilder(
                  transitionDuration: Duration(milliseconds: 250),
                  pageBuilder: (BuildContext context,Animation animation,Animation secondAnimation){
                    return FadeTransition(
                      opacity: animation,
                      child: HeroAnimationRoute("assets/g.jpg","assets/g.jpg"+"$index"),
                    );
                  },
                ),
              );
            },
          ),
        );
      },
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,mainAxisSpacing: 10.0,crossAxisSpacing: 10.0,
      ),
    );
  }
}
class HeroAnimationRoute extends StatelessWidget {
  final String imageName,tag;
  HeroAnimationRoute(this.imageName,this.tag);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black54,
      body: InkWell(
        onTap: (){
          Navigator.of(context).pop();
        },
        child: Center(
          child: Hero(
            tag: tag,
            child: Image.asset(imageName,fit: BoxFit.cover,),
          ),
        ),
      ),
    );
  }
}


