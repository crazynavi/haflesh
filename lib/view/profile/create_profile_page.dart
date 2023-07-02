import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_svg/svg.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide User;
import 'package:the_hafleh/common/values/supabase.dart';
import 'package:the_hafleh/common/values/colors.dart';
import 'package:the_hafleh/common/values/custom_text_style.dart';
import 'package:the_hafleh/common/widgets/button.dart';
import 'package:the_hafleh/common/widgets/static_progress_bar.dart';
import 'package:the_hafleh/common/utils/images.dart';
import 'package:the_hafleh/common/utils/logger.dart';
import 'package:the_hafleh/core/blocs/auth/auth_bloc.dart';
import 'package:the_hafleh/core/blocs/profile/profile_bloc.dart';
import 'package:the_hafleh/core/models/profile_model.dart';
import 'package:the_hafleh/view/welcome/welcome_info_page.dart';

import 'package:the_hafleh/view/profile/widgets/name_input.dart';
import 'package:the_hafleh/view/profile/widgets/birthday_choose.dart';
import 'package:the_hafleh/view/profile/widgets/genders_choose.dart';
import 'package:the_hafleh/view/profile/widgets/hometown_input.dart';
import 'package:the_hafleh/view/profile/widgets/nationality_choose.dart';
import 'package:the_hafleh/view/profile/widgets/religious_choose.dart';
import 'package:the_hafleh/view/profile/widgets/smoke_choose.dart';
import 'package:the_hafleh/view/profile/widgets/drink_choose.dart';
import 'package:the_hafleh/view/profile/widgets/drug_choose.dart';
// import 'package:the_hafleh/view/auth/create_account/welcome_dialog.dart';

List<String> headings = [
  "What's your name?",
  "What's your date of birth?",
  "Which gender best describes you?",
  "Where is your hometown?",
  "What is your nationality?",
  "What is your religious beliefs?",
  "Do you smoke?",
  "Do you drink?",
  "Do you use drugs",
];

List<String> icons = [
  "contact.svg",
  "cake.svg",
  "face.svg",
  "home.svg",
  "contact.svg",
  "religious.svg",
  "smoke.svg",
  "drink.svg",
  "drug.svg",
];

class CreateProfilePage extends StatefulWidget {
  const CreateProfilePage({super.key});

  @override
  _CreateProfilePageState createState() => _CreateProfilePageState();

  static Page<void> page() =>
      const MaterialPage<void>(child: CreateProfilePage());
  static Route<void> route() =>
      MaterialPageRoute<void>(builder: (_) => const CreateProfilePage());
}

class _CreateProfilePageState extends State<CreateProfilePage> {
  List<ImageProvider?> profileImages = [null, null, null, null];
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    User? authedUser = FirebaseAuth.instance.currentUser;
    ProfileModel profile = context.read<ProfileBloc>().state.profile;
    // context
    //     .read<ProfileBloc>()
    //     .add(ProfileUpdated(profile.copyWith(uid: authedUser!.uid)));
    context.read<ProfileBloc>();
  }

  Widget _activePage() {
    ProfileModel profile = context.read<ProfileBloc>().state.profile;
    switch (_currentPage) {
      case 0:
        return step1(profile);
      case 1:
        return step2(profile);
      case 2:
        return step3(profile);
      case 3:
        return step4(profile);
      case 4:
        return step5(profile);
      case 5:
        return step6(profile);
      case 6:
        return step7(profile);
      case 7:
        return step8(profile);
      case 8:
        return step9(profile);
      default:
        return step1(profile);
    }
  }

  Widget _visibleProfilePage() {
    ProfileModel profile = context.read<ProfileBloc>().state.profile;
    switch (_currentPage) {
      case 0:
        return const SizedBox(
          height: 0,
        );
      case 1:
        return const SizedBox(
          height: 0,
        );
      case 2:
        return visibleStep3(profile);
      case 3:
        return visibleStep4(profile);
      case 4:
        return visibleStep5(profile);
      case 5:
        return visibleStep6(profile);
      case 6:
        return visibleStep7(profile);
      case 7:
        return visibleStep8(profile);
      case 8:
        return visibleStep9(profile);
      default:
        return const SizedBox(
          height: 0,
        );
    }
  }

  void createAccount() async {
    try {
      ProfileModel profile = context.read<ProfileBloc>().state.profile;
      User? authedUser = FirebaseAuth.instance.currentUser;
      if (authedUser != null) {
        List<String> photos = ["", "", "", ""];
        for (int i = 0; i < 4; i++) {
          ImageProvider? element = profileImages[i];
          if (element == null) {
            continue;
          }

          Uint8List bytes = await getImageBytes(element);
          final response = await Supabase.instance.client.storage
              .from(SupabaseConsts.photoBucket)
              .uploadBinary("public/${authedUser.uid}_$i.png", bytes,
                  fileOptions: const FileOptions(upsert: true));
          photos[i] = getPublicPhotoUrl(response);
        }
        // ignore: use_build_context_synchronously
        context
            .read<ProfileBloc>()
            .add(ProfileUpdated(profile.copyWith(photos: photos)));
        // ignore: use_build_context_synchronously
        context.read<ProfileBloc>().add(const ProfileCreateRequested());
      }
    } catch (e) {
      logger.e("create account error $e");
    }
  }

  void onBackPressed() {
    if (_currentPage == 0) {
      context.read<AuthBloc>().add(SignOutRequested());
    }
    setState(() {
      _currentPage = _currentPage >= 1 ? _currentPage - 1 : 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    context.watch<ProfileBloc>();

    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.secondary,
        body: BlocListener<ProfileBloc, ProfileState>(
            listener: (context, state) {
              // if the profile successfully created, show welcome modal
              if (state.status == ProfileStatus.created) {
                // WelcomeDialog.showWelcomeDialog(context, onButtonPressed: () {
                //   context
                //       .read<ProfileBloc>()
                //       .add(// after click ok button, move to main page
                //           ProfileWelcomeClicked());
                // });
              }
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                    child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Row(children: <Widget>[
                              const SizedBox(width: 8),
                              Expanded(
                                child: StaticProgressBar(
                                    count: 9, current: _currentPage + 1),
                              ),
                              const SizedBox(width: 8),
                            ]),
                            const SizedBox(height: 12),
                            SvgPicture.asset(
                              "assets/icons/${icons[_currentPage]}",
                              fit: BoxFit.cover,
                            ),
                            const SizedBox(
                              height: 12,
                            ),
                            Text(headings[_currentPage],
                                textAlign: TextAlign.left,
                                style: CustomTextStyle.getTitleStyle(
                                    Theme.of(context).colorScheme.onSecondary)),
                            const SizedBox(
                              height: 24,
                            ),
                            Expanded(
                              child: SingleChildScrollView(
                                child: _activePage(),
                              ),
                            )
                          ],
                        ))),
                Row(children: <Widget>[
                  const SizedBox(width: 18),
                  Expanded(
                    child: _visibleProfilePage(),
                  ),
                  const SizedBox(width: 24),
                ]),
                Row(children: <Widget>[
                  const SizedBox(width: 24),
                  Expanded(
                      child: Button(
                          title: "BACK",
                          flag: true,
                          outlined: true,
                          onPressed: () {
                            setState(() {
                              _currentPage--;
                            });
                            if (_currentPage < 0) {
                              _currentPage = 0;
                              Navigator.of(context).pop();
                            }
                          })),
                  const SizedBox(width: 8),
                  Expanded(
                      child: Button(
                          title: "NEXT",
                          flag: true,
                          onPressed: () {
                            setState(() {
                              _currentPage++;
                            });
                            if (_currentPage >= 9) {
                              _currentPage = 8;
                              Navigator.of(context)
                                  .push<void>(WelcomeInfoPage.route());
                              // createAccount();
                            }
                          })),
                  const SizedBox(width: 24),
                ]),
                const SizedBox(height: 16),
              ],
            )));
  }

  Widget step1(ProfileModel profile) {
    return NameInput(
        firstname: profile.firstname ?? "",
        lastname: profile.lastname ?? "",
        onChangeFirstname: (firstname) {
          context
              .read<ProfileBloc>()
              .add(ProfileUpdated(profile.copyWith(firstname: firstname)));
        },
        onChangeLastname: (lastname) {
          context
              .read<ProfileBloc>()
              .add(ProfileUpdated(profile.copyWith(lastname: lastname)));
        });
  }

  Widget step2(ProfileModel profile) {
    return BirthdayChoose(
      birthday: profile.birthday ?? DateTime.now(),
      onChange: (DateTime? value) {
        context
            .read<ProfileBloc>()
            .add(ProfileUpdated(profile.copyWith(birthday: value)));
      },
    );
  }

  Widget step3(ProfileModel profile) {
    return GendersChoose(
      gender: profile.gender,
      onChange: (value) {
        context
            .read<ProfileBloc>()
            .add(ProfileUpdated(profile.copyWith(gender: value)));
      },
    );
  }

  Widget visibleStep3(ProfileModel profile) {
    return CheckboxListTile(
      contentPadding: const EdgeInsets.all(0),
      value: profile.genderVisibility ?? false,
      activeColor: Theme.of(context).colorScheme.primary,
      checkColor: Theme.of(context).colorScheme.secondary,
      controlAffinity: ListTileControlAffinity.leading,
      onChanged: (bool? value) {
        setState(() {
          context
              .read<ProfileBloc>()
              .add(ProfileUpdated(profile.copyWith(genderVisibility: value)));
        });
      },
      title: const Text("Visible on my profile"),
    );
  }

  Widget step4(ProfileModel profile) {
    return HomeTownInput(
      town: profile.town ?? "",
      onChange: (value) {
        context
            .read<ProfileBloc>()
            .add(ProfileUpdated(profile.copyWith(town: value)));
      },
    );
  }

  Widget visibleStep4(ProfileModel profile) {
    return CheckboxListTile(
      contentPadding: const EdgeInsets.all(0),
      value: profile.townVisibility ?? false,
      activeColor: Theme.of(context).colorScheme.primary,
      checkColor: Theme.of(context).colorScheme.secondary,
      controlAffinity: ListTileControlAffinity.leading,
      onChanged: (bool? value) {
        setState(() {
          context
              .read<ProfileBloc>()
              .add(ProfileUpdated(profile.copyWith(townVisibility: value)));
        });
      },
      title: const Text("Visible on my profile"),
    );
  }

  Widget step5(ProfileModel profile) {
    return NationalityChoose(
      nation: profile.nation ?? ["", ""],
      onChange: (value) {
        context
            .read<ProfileBloc>()
            .add(ProfileUpdated(profile.copyWith(nation: value)));
      },
    );
  }

  Widget visibleStep5(ProfileModel profile) {
    return CheckboxListTile(
      contentPadding: const EdgeInsets.all(0),
      value: profile.nationVisibility ?? false,
      activeColor: Theme.of(context).colorScheme.primary,
      checkColor: Theme.of(context).colorScheme.secondary,
      controlAffinity: ListTileControlAffinity.leading,
      onChanged: (bool? value) {
        setState(() {
          context
              .read<ProfileBloc>()
              .add(ProfileUpdated(profile.copyWith(nationVisibility: value)));
        });
      },
      title: const Text("Visible on my profile"),
    );
  }

  Widget step6(ProfileModel profile) {
    return ReligiousChoose(
      religious: profile.religious ?? "",
      onChange: (value) {
        context
            .read<ProfileBloc>()
            .add(ProfileUpdated(profile.copyWith(religious: value)));
      },
    );
  }

  Widget visibleStep6(ProfileModel profile) {
    return CheckboxListTile(
      contentPadding: const EdgeInsets.all(0),
      value: profile.religiousVisibility ?? false,
      activeColor: Theme.of(context).colorScheme.primary,
      checkColor: Theme.of(context).colorScheme.secondary,
      controlAffinity: ListTileControlAffinity.leading,
      onChanged: (bool? value) {
        setState(() {
          context.read<ProfileBloc>().add(
              ProfileUpdated(profile.copyWith(religiousVisibility: value)));
        });
      },
      title: const Text("Visible on my profile"),
    );
  }

  Widget step7(ProfileModel profile) {
    return SmokeChoose(
      smoke: profile.smoke ?? "",
      onChange: (value) {
        context
            .read<ProfileBloc>()
            .add(ProfileUpdated(profile.copyWith(smoke: value)));
      },
    );
  }

  Widget visibleStep7(ProfileModel profile) {
    return CheckboxListTile(
      contentPadding: const EdgeInsets.all(0),
      value: profile.smokeVisibility ?? false,
      activeColor: Theme.of(context).colorScheme.primary,
      checkColor: Theme.of(context).colorScheme.secondary,
      controlAffinity: ListTileControlAffinity.leading,
      onChanged: (bool? value) {
        setState(() {
          context
              .read<ProfileBloc>()
              .add(ProfileUpdated(profile.copyWith(smokeVisibility: value)));
        });
      },
      title: const Text("Visible on my profile"),
    );
  }

  Widget step8(ProfileModel profile) {
    return DrinkChoose(
      drink: profile.drink ?? "",
      onChange: (value) {
        context
            .read<ProfileBloc>()
            .add(ProfileUpdated(profile.copyWith(drink: value)));
      },
    );
  }

  Widget visibleStep8(ProfileModel profile) {
    return CheckboxListTile(
      contentPadding: const EdgeInsets.all(0),
      value: profile.drinkVisibility ?? false,
      activeColor: Theme.of(context).colorScheme.primary,
      checkColor: Theme.of(context).colorScheme.secondary,
      controlAffinity: ListTileControlAffinity.leading,
      onChanged: (bool? value) {
        setState(() {
          context
              .read<ProfileBloc>()
              .add(ProfileUpdated(profile.copyWith(drinkVisibility: value)));
        });
      },
      title: const Text("Visible on my profile"),
    );
  }

  Widget step9(ProfileModel profile) {
    return DrugChoose(
      drug: profile.drug ?? "",
      onChange: (value) {
        context
            .read<ProfileBloc>()
            .add(ProfileUpdated(profile.copyWith(drug: value)));
      },
    );
  }

  Widget visibleStep9(ProfileModel profile) {
    return CheckboxListTile(
      contentPadding: const EdgeInsets.all(0),
      value: profile.drugVisibility ?? false,
      activeColor: Theme.of(context).colorScheme.primary,
      checkColor: Theme.of(context).colorScheme.secondary,
      controlAffinity: ListTileControlAffinity.leading,
      onChanged: (bool? value) {
        setState(() {
          context
              .read<ProfileBloc>()
              .add(ProfileUpdated(profile.copyWith(drugVisibility: value)));
        });
      },
      title: const Text("Visible on my profile"),
    );
  }
}