import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:user_repository/user_repository.dart';
import 'package:very_good_blog_app/app/app.dart';
import 'package:very_good_blog_app/profile/profile.dart';
import 'package:very_good_blog_app/setting/bloc/edit_profile_bloc.dart';
import 'package:very_good_blog_app/widgets/action_bar.dart';
import 'package:very_good_blog_app/widgets/dismiss_focus_keyboard.dart';
import 'package:very_good_blog_app/widgets/text_field_decoration.dart';
import 'package:very_good_blog_app/widgets/title_of_text_field.dart';

class EditProfilePage extends StatelessWidget {
  const EditProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<EditProfileBloc>(
      create: (context) => EditProfileBloc(
        profileBloc: context.read<ProfileBloc>(),
        userRepository: context.read<UserRepository>(),
      ),
      child: const _EditProfileView(),
    );
  }
}

class _EditProfileView extends StatelessWidget {
  const _EditProfileView();

  @override
  Widget build(BuildContext context) {
    return BlocListener<EditProfileBloc, EditProfileState>(
      listener: (context, state) {
        if (state.loadingStatus == LoadingStatus.loading) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              const SnackBar(
                content: Text('Đang cập nhật thông tin'),
              ),
            );
        } else if (state.loadingStatus.isError) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Text(state.errorMessage),
              ),
            );
        } else if (state.loadingStatus.isDone) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              const SnackBar(
                content: Text('Cập nhật thông tin thành công'),
              ),
            );
          context.read<ProfileBloc>().add(ProfileGetUserInformation());
          context.pop();
        }
      },
      child: DismissFocusKeyboard(
        child: Scaffold(
          body: SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: 16,
              vertical: context.padding.top + 16,
            ),
            child: Column(
              children: [
                Builder(
                  builder: (context) {
                    final enableToEdit = context.select(
                      (EditProfileBloc editProfileBloc) =>
                          editProfileBloc.state.enableEditing,
                    );
                    return ActionBar(
                      title: enableToEdit
                          ? 'Chỉnh sửa thông tin'
                          : 'Thông tin cá nhân',
                      actions: !enableToEdit
                          ? [
                              IconButton(
                                icon: Assets.icons.edit.svg(
                                  color: AppPalette.deepPurpleColor,
                                  height: 28,
                                ),
                                onPressed: () {
                                  context.read<EditProfileBloc>().add(
                                        const EditProfileEvent(
                                          EditProfileType.enalbeToEdit,
                                        ),
                                      );
                                },
                                splashRadius: 24,
                              ),
                            ]
                          : null,
                    );
                  },
                ),
                const SizedBox(
                  height: 24,
                ),
                const _UserAvatar(),
                const SizedBox(
                  height: 32,
                ),
                const _UserProfileForm(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _UserProfileForm extends StatelessWidget {
  const _UserProfileForm();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const TitleOfTextField('Họ của bạn'),
        _FirstnameInput(),
        const SizedBox(
          height: 16,
        ),
        const TitleOfTextField('Tên của bạn'),
        _LastnameInput(),
        const SizedBox(
          height: 16,
        ),
        Center(
          child: _UpdateProfileButton(),
        ),
      ],
    );
  }
}

class _FirstnameInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final firstname = context.select(
      (EditProfileBloc editProfileBloc) => editProfileBloc.state.firstname,
    );
    final user =
        context.select((ProfileBloc profileBloc) => profileBloc.state.user);
    final enableToEdit = context.select(
      (EditProfileBloc editProfileBloc) => editProfileBloc.state.enableEditing,
    );
    return TextFieldDecoration(
      child: TextFormField(
        readOnly: !enableToEdit,
        initialValue: user!.firstName,
        key: const Key('editProfile_firstnameInput_textField'),
        onChanged: (firstName) => context.read<EditProfileBloc>().add(
              EditProfileEvent(
                EditProfileType.firstNameChanged,
                input: firstName,
              ),
            ),
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.only(left: 16, right: 16),
          border: InputBorder.none,
          hintText: 'Nhập vào họ của bạn',
          errorText:
              firstname.displayError != null ? 'Họ của bạn không hợp lệ' : null,
        ),
      ),
    );
  }
}

class _UpdateProfileButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isValid = context.select(
      (EditProfileBloc editProfileBloc) => editProfileBloc.state.isValid,
    );
    final loadingStatus = context.select(
      (EditProfileBloc editProfileBloc) => editProfileBloc.state.loadingStatus,
    );
    final enableToEdit = context.select(
      (EditProfileBloc editProfileBloc) => editProfileBloc.state.enableEditing,
    );
    return loadingStatus == LoadingStatus.loading
        ? const CircularProgressIndicator(
            color: AppPalette.primaryColor,
          )
        : Visibility(
            visible: enableToEdit,
            child: ElevatedButton(
              key: const Key('editProfile_confirmedEdit_raisedButton'),
              onPressed: enableToEdit
                  ? (isValid
                      ? () {
                          context.read<EditProfileBloc>().add(
                                const EditProfileEvent(
                                  EditProfileType.submitted,
                                ),
                              );
                        }
                      : null)
                  : null,
              style: ElevatedButton.styleFrom(
                fixedSize: const Size(120, 50),
                backgroundColor: Theme.of(context).primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
              ),
              child: const Text(
                'Cập nhật',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                  color: AppPalette.whiteBackgroundColor,
                ),
              ),
            ),
          );
  }
}

class _LastnameInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final lastname = context.select(
      (EditProfileBloc registerBloc) => registerBloc.state.lastname,
    );
    final user =
        context.select((ProfileBloc profileBloc) => profileBloc.state.user);
    final enableToEdit = context.select(
      (EditProfileBloc editProfileBloc) => editProfileBloc.state.enableEditing,
    );
    return TextFieldDecoration(
      child: TextFormField(
        readOnly: !enableToEdit,
        initialValue: user!.lastName,
        key: const Key('editProfile_lastNameInput_textField'),
        onChanged: (lastName) => context.read<EditProfileBloc>().add(
              EditProfileEvent(
                EditProfileType.lastNameChanged,
                input: lastName,
              ),
            ),
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.only(left: 16, right: 16),
          border: InputBorder.none,
          hintText: 'Nhập vào tên của bạn',
          errorText:
              lastname.displayError != null ? 'Tên của bạn không hợp lệ' : null,
        ),
      ),
    );
  }
}

class _UserAvatar extends StatelessWidget {
  const _UserAvatar();

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.bottomRight,
      children: [
        Builder(
          builder: (context) {
            final avatarUrl = context.select(
              (ProfileBloc profileBloc) => profileBloc.state.user?.avatarUrl,
            );
            final imagePicked = context.select(
              (EditProfileBloc editProfileBloc) =>
                  editProfileBloc.state.imagePath,
            );

            if (imagePicked != '') {
              return CircleAvatar(
                radius: 70,
                backgroundImage: FileImage(File(imagePicked)),
              );
            }
            return CircleAvatar(
              radius: 70,
              backgroundImage: avatarUrl == null || avatarUrl.isEmpty
                  ? Assets.images.blankAvatar.image().image
                  : NetworkImage(avatarUrl),
            );
          },
        ),
        Builder(
          builder: (context) {
            final enableToEdit =
                context.watch<EditProfileBloc>().state.enableEditing;
            return Visibility(
              visible: enableToEdit,
              child: Positioned(
                bottom: -2,
                right: -2,
                child: CircleAvatar(
                  backgroundColor: AppPalette.purpleSupportColor,
                  radius: 19,
                  child: Align(
                    child: IconButton(
                      icon: Assets.icons.camera.svg(
                        color: AppPalette.primaryColor,
                      ),
                      splashRadius: 24,
                      onPressed: () => context.read<EditProfileBloc>().add(
                            const EditProfileEvent(
                              EditProfileType.chooseImageButtonPressed,
                            ),
                          ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
