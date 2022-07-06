import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_php_projects/widgets/text_input.dart';
import 'package:http/http.dart' as http;

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isLoading = false;
  late String errormsg;
  late bool error, showprogress;
  late String username, password;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  startLogin() async {
    String apiurl = "http://192.168.0.112/test/login.php";
    var response = await http.post(Uri.parse(apiurl), body: {
      'username': username, //get the username text
      'password': password //get password text
    });

    if (response.statusCode == 200) {
      var jsondata = json.decode(response.body);
      if (jsondata["error"]) {
        setState(() {
          showprogress = false; //don't show progress indicator
          error = true;
          errormsg = jsondata["message"];
        });
      } else {
        if (jsondata["success"]) {
          setState(() {
            error = false;
            showprogress = false;
          });
          //save the data returned from server
          //and navigate to home page
          String uid = jsondata["uid"];
          String fullname = jsondata["fullname"];
          String address = jsondata["address"];
          print(fullname);
          //user shared preference to save data
        } else {
          showprogress = false; //don't show progress indicator
          error = true;
          errormsg = "Something went wrong.";
        }
      }
    } else {
      setState(() {
        showprogress = false; //don't show progress indicator
        error = true;
        errormsg = "Error during connecting to server.";
      });
    }
  }

  @override
  void initState() {
    username = "";
    password = "";
    errormsg = "";
    error = false;
    showprogress = false;

    _emailController.text = "defaulttext";
    _passwordController.text = "defaultpassword";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: secondaryColor,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(colors: [Colors.purple, Colors.amber]),
              image: DecorationImage(
                  fit: BoxFit.fill,
                  image: NetworkImage(
                    'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAATIAAAClCAMAAADoDIG4AAAA3lBMVEV3e7P///8AAABITImustV1ebJyd7Hd3d1xdbB5fbWpq86/v7/Ky+BwdLBGSohwdKfX19d0eKpscKT09PStsdWJjLxna6D4+PssLCxpbaJLT4ubm5uxtddbX5e7vNd7f69VWZNYXJWansY7QIPb3Orj4+OLj7ujp82AhLM5PoJeXl7Pz8/v7++Kjrrs7fQ8PDwaGhqysrJUVFS2trbX2Oifn5+IiIhwcHBCQkIQEBB8fHzl5vBKSkomJiZzc3OYmrqxssp5fKfJytq8vtSNkLWnqcNydaGNj7FmaZrKy9oKPkBLAAAYAklEQVR4nO2dC1fazBaGSTUxQUDFQkQB5SJgFVpbrLWpHyra1v//h87eM7nPnmQSArZn9V3rrNOvRUye7Hln77mlpP1TRpXe+gL+Pv1Dlln/kGXWn4HMtu3ZzHGGw/l8XuHqdpcg9kf4y6HjzGbwqbe+UNQbIgNMznCOcLrt9vb7kMrl8pir72qEgv8fl8vdZWXozN6Q3hsgg4ACUoDJBbS9jf8Li6TmchtNG43JpDF97pe7wO4NyG0UmQ2svIgSOEWIkchcZqMpCLBNTk8PTifT/ktlONvkXWwIGcCCuNr2wipNjNk4iVljOmE6BW57ewen03JluKGI2wAyoNXmcZVEqR2WjFoozKYBM6AG2Fr1+sFiuQFu60VmO5V2WR5YLqD3ZQZlNGqAJlZMp8AF/6ExCiQiQ2iArdnpHCyenLXe1PqQYXCVaVg8jADTCBHphmHorkqlkv8H74/8z/4/cIgT7AR8ZIwZQKuDAFuv87wcru3G1oPMHlbel4ngQlaACkghKI7DI6KugJ2nAxcZMmu1Wk0ItjPAtp7+tHhk0Bi7YnRhP1ke94FVCVHlACWVZR34yPZcZE1G7bi5eCq+My0YmT3sCtkD0gJY0AILZhWT2zI9ZMAMqZ09PhQcbEUim8278cYI3u7RWiOskDDMAmKg3tnxVn1RZEdaGDLGK4pru9wfTSxD3wirkHRGzUPW652dHdeaxVErBpnAq90u9xsW4NpMbMVklXSj1QwhA2hbtc6imF60AGTgXxFe0Bj7I6ukbzy64tjqzQAZQDuu1TovBaRsKyNzKjFe5f5Ef2NcrizA1uq4xADZ8fHWYPDz6W2R2fNI/9huQ3j9EbR8ATaz4yMDaLWL2mK1UFsF2awS7iDb2/3GHxJeUUHRBdSOXWSgwcVKoZYf2RDKoQgvyFFXujWdUOHUtphqF2cPuTvQnMjseTvMazyyVuQFfVxDVIExCy201XOJIbRBbZGzMMiFzK6ELKw9Hp0WEA/WnPhFzqjIdg5JT/OsVvOoDQbPuUwtBzI71EeyBllELJgUMbBLq1hvhAbaO675kZYLWmZkGGGhACvolvQJWMthXPDr+kV3J5alQ6iFoGXObzMiCwFrt8eNwjIKvQ/f/e0oqo+Ha0BWwizXDNonQMvoadmQzQNg25ixFnYXRlvTdt7F9BF+Y2MtSQu4WieAVltk6j2zIBu2PRODnLVYk6mCle3Gkf1XvJf5gvbZ2QqgPawF2awbAVbsrRhgw1/jyK7hKVUL/TURhaDVBmd097MSsko5aJLF5/jo/p/jyC41bWkW/IsisqwA2sWjqqUpIhsG3WTBTZLJGIH7H8WRXWna2Cj8d0VklUKRptg6lZDZXb826p+uo4o0tgn3P4LfXGgqSwo6Ai+3vfiplKWpIPNDDNKK9dyCWdG0yziy2zW6f1iWeZYp0NKR2Z7tt9+v7Zmj+58Q7u+s0f0DWVbLqwhUAi0VmeO72DpMzLtocP8PhPtXNoKMd55uoNWWqyKrjN/7bXJtxPQGBPPHODLI/ctrdv9AluG2ztrFc0pim4zM7o7dUcTROuc9zLKmnceJ3WmbcH9fVqnpJbad5MaZiMwpc2Lt8mSt1066/wd4Yptwf19BoNUSB22TkM3H4zIuFWivozYOy6Tc/2ZT7u8LMluvcb7kQ1ZBYpCQvW+s2VF0HdzjNo5sF65grbk/IcvkXSfUAnmQdccsyLbHa28dzP2/Ee6/vWlk4Ghu4xz8lnYCMmR2u8+R9dM6SkNBupG0JsMA97+KE3sHFzEyVb9EV7kIXWXy3nJHhWodWc0pQWaXkRggS033jVE5TWyJYsPSqyaNvwruv0+5/3boO/gCPviSKrHIw2yMVa5i1JhYVTNlkYhVdTO0Y0nHSSOzx32+SDWtp9QN5UETezbs9ieATUQ21LQbwv2pL3GGFcgQq9G7rrbVL8KpQBgQFxFi5hlajWZGIvOJpdqY2VW9WO+W241qvDepgm38R7i/VLNK3wjZHHphJsHPmwnULJ0bmiTOKGRAjCHrWynA4G6hwV/tpOn8/Oow+PphPwbNgr/8EUd2KXzH+VX4rruWDw2f22HGi5i1S/K+xWd2RjEjkIGPMWQKxPQSVRyKuvt09O3z9y/77jU7/XDCZYwp9ye+5B6/5PrSJWdvV91AwVHwa5WLuP/44zb4+XZVGmhWqecyI/oAAhkSA2R9hRIJhwY1hbv19OnDF05trgeBhu4vDJYl3frHkx0erq5vYMMWRsETfv6b+/OzhjxVtlxmHTHXEJF12aaEcWpygTK3oUlkuFvULbtee+RfLun+KfrGrG42QfC6rhGj4Mn6wa2yncps8DMdWWXEN3Io5a9YHAoTQ6m6ZU1j7F0uBsn3zF/yEcnbpzqfA80S6lxHl+xuE5hxPxv8SkM2d4mpAIO7dbIHCOqaGYB7uaT7K36JA9kpur+KF8Z1y+43oRPgucZFfKQ2hmzmElMrklTdX3K5Y3a5Rj974+bC1K1bZe7/Jc/P359jnEmzDat0zOvNeSKyMUeW3ldyZOj+d7lu9wf+thFakbnM5v4hQduyJzomOsI4iJp2OHQZM53NPtXO7ARkS05sokaMFYf5AuTdu88Y0/gl6P4KKQKlI7iXrokNO6P7e7o79x4czczkdvYsR+ZMGTLlaaQqNTSoqu/4iKqZU4SIwM5mRi73d4UrZRx5buAOoF0spcj6bP/2SBEYd/+cAfKOl0TwdPK6Pwqbd6Odz/25/oNvaMvHA3m3WavZEmTLKUOmPD6mW9TQoLLuD9F8VwqSd9CwyrkSHV/ohwlhprNuM9I0Q8hmbJNov6EcZKwcvs9/tSfo3pgiCFMlWW64Qo2CqwsDtZyQaTR50xySyMp8R636GCwWh4L73+3uB7q83L2++S5Mt7nCMGuTBeLnm5OIvt4KCza4IM8YUonOyU7sIr5KOwig7iSM/rpN8zeFzOE7kTMMW2N6ILj/N43QLp287eKMCOX+18R3fKHIQx9iUw37nPiCfbqTwRQxIamyDD6NHkw6Bcj6UySWZdEFmR58oJBB26OeMn4WG7fg/tQdk/3qf+wfhFD/dEV+Ad0zXyW2TLfXrPVEZEM3yNSJ6daMGBq8wbEsX8vK3NvUR1zuPVxtlwiSO/h7ZxjImfHvEKZUeBUhuj8mfd3wVXgnaVD9xGVi2QT3yXuApYBszINMnRh3f6G1sJUUpq8qqLHNRuqIxrkPfAn3xzs2qhE1ujaV0Hxn1y6UufDXs/BFwGVYY1b3EDnRV/xwwn3yHiBwMw/ZrDGdZgsy7v5CuXQurqTQjerYJvtF7llCgYh3HHvuerVLpc1fNfJh4JLReOAY1YZDPWMWqclzzDzM5jFk3QkiyxJkbARBmBjCVdREp1vF7Eu0M37H1DIpYZEsrtsQS1HOXPjrHSykhItgeaQYZh/tRP/33ew5isxmp3VkCjLm/kKA4FzaKfVhslDgViS4/w6xSJZGto8/L+T+6P59IqWnh4nuDtPWyut88mQWQTacsLOHshDTSzNiaPBEkuVUqYTE7V6Fe6Du2CQbJutahb/G9JSaTpQMRqbuyLDOwpWmi+yBITvNspRAJ9MD2To6Okg+kEFC3nGVqouODkn3l24YmGhUuZKOrMVa5mMYmT1iyDK1S3xkh8LvP5espMC+QvT/D2THj3cslH1Vqi76rO7+/N5J/0/f92OFWyZH5pxOoMfMtnaYdP97jXYRNrQmIrsl3f+GumNybSjvPoTnts+HlbIgS17cZPVYy3wNIVueTrK2S3oPzWestKlP4yYlATBP3oWOdJ9o3Gz6Tyg0d8mGjQOH5IYB5iWf4h+/T7V/NzUbLELIynhUU8Z2qUvcP55RcWE9KqbeX0n3p+6YjtId0v2xzCUZ0PafmmTgTzIz+xkgAyubQJhlW0c2oQJkVzbPRWYkbMJDAEHeMbk29J7VUULuwjYMUBdhkgPvH1JTWZxtCubOGbIZHgQ2zbYelrm/0FJ2ZGOcxoyqMvcp97+lFsma1PQfm3MRBzlvZMM59MA7hLqdioynGY6PzDlgp6dlQkbuoMR1dGTnozdsqqo+p1IE8o5xCEDi/mSZSyMj8+kbhQ15vADgI0AM2StDRiXtcpmU+/9gs2TEp+l6lKVV5BaJ+B3TQwDc/eNfe0eUue6NkwPvKlsyXP9/8JEt2VF9mdyf3kEpHRSgm8QHMkWg7pildQLyfdL9JWUun2Qmkn+VDXl8eo53mQxZNwcyiwqQL5o2p5CxoTVxgP6Ecn/yjsm1oXca6f5swwB1yeSXsHQ49dYtg3WZv3xkL9mRYZ5Euj8xguA+XzGH3KeChLxjk1od9JEhowY5affHdik+t6+yvCiqYDAjN7I2lSfJ3B9TDPH5HpEFIlXYsygVXIiPLwqdisz9McUQE1kycRZlBVUmR3aAzLIQo/MkeOw2lUOytRvieqjvZIFIubGOSaAwBPCFub8A4Zwey2e5t+iniidLCMhOT7NGmSlxfyrD0fHDxJjsPpkiUIU9NmyRDft5ssylllngsC4xLY/XrLKlTYyy02zI2MpBoaVc0+7PLlYMsm9kinBE3TG9Ooi1S6Gk+Ey7vzmi0mb2hFR2feoxL+tmRwZ50qEQIKT769Uy5fJuuxL+nizsTWr6j1mh6iCngbm0uOOfjaXIl/74EnrMJSA7zYTMlO2hEetptjXgSrzYIzpFIN2fHALg7q9U5urVvk1GOjZuR2FXm1WN5WXzPUSWJfuXuX+0ntYN0+zLJuS+0AUiWdiTS8jYVMkVlQlHy1zdrDYq+Fli5cYt9ZQpZPHs39ljJ01nQEaOkTL356fbGQZOH+qjLgN2SBBzFyIIKQJV2Ouk+7P1wXSZa7pXYRrVqtko8zUo1FqXc77cNh0ZrzFffWSHp5mRUTkkHjngrrXtj7e7Fe+g5UtqDQpfQyCAuKNSO3p1EPsCssz13g8wLrcrQ3em/Ypa1YXlR8qArIvsjJ0JEQz+2NODbMjo/fP7GqUdcgUaXqxDpAhkYU+uDvrEvl1IdE7Iizg8oZb0opOQBZ6IjA3+92wfmVZmyNT9n14kS1zq1Rd6gSKOdA0pEGT5YlLuz1ewCE2e2i62KzQIrivZwItAzAhNMXFkFWZmB8rIyIGJyDKpw/P93ZtbsTwJLlYjV8HsEs9dL1Fs2O5DscyNrPm52t+9/ipb3sboJq35CSHj7v8SQjbby9Yy826R8IRj9n2yG8TUjnL/Q9r9869/5E1YrVl6g7LDELKsZobun30PjS98vBVcpiGmCNqK7q8uTOtmqke7boXW/7uz5S8szFTNjB4jVRYSG1YRBHWWoFjYk9tHJO6vLCRmT9TOZnDbpbuOxVuTsXdwoB5mq2yR4MQg4yZBkMO6VWqqha+Ayb0enE0bKFRKHBlrl4OnCDJtcoDMFMOMHt5U0z16kGNBnkl1g9Swrm5mcH9F3WQiZobbZbC+rJ4hzPLsoHT144oTk4yEU4U9GwCm3T/nFok7lomMVE/h4Fsz3bny0CpG9o4ZVWS5dlCiWKI5t9xdlKT7i4U9uX3kML/7f8DHZqvGGFwAPw5uGEOmLfYQmVJqxsZI87j/N7YgoMK6KbIbxNEN0v0FNtz9c22RYOW8o+j8JX8Ro7/910fm1JXDDGfIcuyhOeKJeZlvgDQl7i8O65KbB3O7/wlzpIquTowv/PeXyobX/e+xtqnwJeQyqTR95sCciRmAUDpJlnZ/1sKJIcNkfbphwOy+WgbLkfVi20tCu0taqsiy76D8fM3rGLvsHbSgGxSIfYn7i/tk2QPIlugcnbjjBhUzw1FZ7p7M0Nbf8B6muiKzDDso7+5/fP9y6f4CuxucKcK6QeHj6u7PHoHqXtBPH2+vd71zReYT+fkYlFhO5i36jCGzW2pNk879b3Zjury83AlvrJm19dC16uCHdvxHdin3Z8uoqU9SDid87vJy/zx0CItdyQjM28QaOmIksh9TrWnS7i/ZNeReqdMdVaP1nEV/Usz92To6WtQgZ4JmlbGReEASQczdKh0+NS+y63eqFGZ0cXio0cIDpcaTqmAfkgOWiFnYakXGQHB/epDTPVBqZFSzv2CFH2LQC39ZBNmMh1kKM7I4xE6/EtGy28W3O1omnhhGke8vK3F1yTMMzbHwwUq3S3khPLd5/HPb4/5owo49y4rL7y0vhlJk2rK5p4CMSg++4tZK0wxvtTIN00i6Tt0URX/cqAoflA5yWuHPVvE/jNxvJ3K3/PqlEoVMe66nMmOvGaFWxykO1xUjcpATB3QKvAjXyMI7fglk9uleGjN6WbMwe7hmkWVuseeqQtpfow7Li5/5M2ylMTMo98clnOp17upiiQ7l/sWdqm3p7vk18XN5xZOlmindJun+uIQz2yrI1YSDnGSiU9g7FVxiW+KpvOL5ZQ8pzKTuv8nDmemTAGx6g1weWXzfavzwGhqZtkisApj7C5OTuyn7s4sWWebizGZB7dI9UmRr8CjyoY6vfE5ixtxfqJKpubR1inR/2V7Q7PLOryTPMCYPSUVmexJm5BaJozW9l0sm2v0Le6eCZbgny5KnPtNH8SbEGbmVFBeCZ1tru5qkZW4h71SwTO781NmVUmTaVJprkAfN45EDm3x3NH0SQPomQSVZLX7i84AmJj1W/Lm5RzdO8iVTG8/9Kfe/VVwonCLvXHHpWezSw+tfgBkRaGyMlNpmS26RWJdMapCzEPcPTq9/lJ1eLz/v/4Ex24sxw5NkhYmh+427P1XmSjfIZZBn/FsXYj6WjkxbNusiM+kIwppeakWK3r8lOwkggyz3lS+Jb+JIenfJcK8uNE7yJVP/J+7vZWNbtUG8rlRFps0m2DgjnQB5kMCX9b6VUZCszKU3yKnKf+fXoJf4VqGUV1eVPWYeNOwwQyfQcR1u2P2xw7yKX8S52gp+mSy9570kTWr8Ssi0p3o9Emim5G3Cmxz5YRUIpfzPLXitXPqr+FLfKec2Tg+a3iDfgrLRArOkG+QMyjD3u3z8t1ZB/pr6hmmFlz0+NOshaLrV346r3Njw2390s18WrkJpAT+l4L2itYtf6W9KVnk/pjNphlqnLk5z5Jm8WVFs+4rKVEuqLKvpvepx0HtVwKH24tpooP0/yQq9UFQlxJSRYaDt7bnU3vouC1QEWEfx/Ujqb5Rutur/Z9Asy/ASi5Q37+VDptmLZr3uhdpb320BsoJuMssruLMgw7Ptmx6zvx5aqElCKqbaJjMjw7VZAM3D9tZ3vYKsUisErJf6et8VkOFZN0Gk/aWhZlm6n1YAsLMHpX4yPzLN/suhQYvshYG9ZASWA5kL7e+khgF2VgtMPwewXMjY8slOC6nV/yZXs6xSKMAQWNYmuQIy0Py5A6H291CzoEF2jmshYL+XuYDlRwYpx4JB87HppU2uY8kk4GV0jrd8XluDi0eVarJoZNA+H+ouNT/v+AOpcV5BfEGADRbJL3NfHzLQfNqBQiqkP6yFxtsj9JEXnWxpWNHING32cNCMUdv8UBApi/WPW7UIsOOVAqwYZKDhoh6j9ubYEFc0vJDX1goOFqgIZOBqr89gay1QDNsbeBvQKumtDoZXhFft51K99E5SMchAh08etZA4to1xszC4jKaAC+ProRheWoHIQLPXxUGnKWCr1zfADWmVDAiu4ygu9Pvjx4Lii6tIZCB7+PLYiWNj/1nHl9JbayBnsdgymyIt3j/+epXtFcqpgpGhZstFvQfYCCE4NyKKQQWRxWCJtBBX7fHFyZniJ2gNyDTcGfcw7UiwITmGznJvOgcoFletZqcHrERYaF4XF79f5sXjQq0HGdNw+QzYpNyaHR52btwFMBKE5+7BD/bO2FnyIisPV/3ldT24UGtEhnKWi70z4NYJk+rgf3cE8fhrtcJzk8wJ8bO9Hm99XAQqhnAwuIC+MXW+ezWtGRnKhnBrdTDgEIuIiqvHdBbWcUgkpCitwfHjw2uRXaNEG0DGZA+fXqbYpHpJxKLIItCSWNWOfz8v5xugxbQpZFwzAPd8AF0cqNeL4YrzkgOrsRaKrM5+Py6W85XLxkzaLDIu2xm+PiymPzHxBMVJkcBqno+BXV3Ujnu/fz6/LIfOpiIrrLdA5smeAbvly+L58XHvN89E4xqgLkAQUJ3fPx+ffy0envz3Zb6N3hJZSLY9AznD+evTcvkAegHh/z8sl0/zoePAv9pvySmkPwTZ36R/yDLrH7LM+ocss/4HxkIyhoY/RYUAAAAASUVORK5CYII=',
                  ))),
          padding: MediaQuery.of(context).size.width > 600
              ? EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width / 3)
              : const EdgeInsets.symmetric(horizontal: 32),
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 40),
              const Text(
                'Login ',
                style: TextStyle(
                    // color: mobileBackgroundColor
                    fontSize: 25),
              ),
              // Flexible(
              //   child: Text('Welcome to DigitMoni'),
              //   flex: 1,
              // ),
              SizedBox(
                height: MediaQuery.of(context).size.height / 3,
              ),

              TextFieldInput(
                hintText: 'Enter your email',
                textInputType: TextInputType.emailAddress,
                textEditingController: _emailController,
              ),
              const SizedBox(
                height: 24,
              ),
              TextFieldInput(
                hintText: 'Enter your password',
                textInputType: TextInputType.text,
                textEditingController: _passwordController,
                isPass: true,
              ),
              const SizedBox(
                height: 50,
              ),
              InkWell(
                child: Container(
                  child: !_isLoading
                      ? const Text(
                          'Log in',
                        )
                      : const CircularProgressIndicator(
                          // color: primaryColor,
                          ),
                  width: double.infinity,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: const ShapeDecoration(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                    ),
                    color: Colors.grey,
                  ),
                ),
                onTap: startLogin,
              ),
              const SizedBox(
                height: 0,
              ),
              // Flexible(
              //   child: Container(),
              //   flex: 2,
              // ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    child: const Text(
                      'Dont have an account?',
                      style: TextStyle(
                          // color: mobileBackgroundColor
                          ),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 8),
                  ),
                  GestureDetector(
                    // onTap: () => Navigator.of(context).push(
                    //   MaterialPageRoute(
                    //     builder: (context) => const SignupScreen(),
                    //   ),
                    // ),
                    child: Container(
                      child: const Text(
                        ' Signup.',
                        style: TextStyle(
                          fontSize: 20,
                          // color: mobileBackgroundColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 8),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
