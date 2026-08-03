# TeleCare Doctor App

A Flutter telemedicine app built for a doctor workflow: sign in, review an appointment, conduct a one-to-one video consultation, and keep session notes.

## What is implemented

| Interview requirement | Implementation |
| --- | --- |
| Doctor login | Firebase Email/Password sign-in with required-field, email-format, and password-length validation. Login, loading, and Firebase error states are handled. |
| Dashboard | An authenticated doctor lands on a dashboard showing one upcoming appointment. Logout is available from the app bar. |
| Appointment details | Displays patient name, ID, age, phone number, appointment date/time, and a color-coded `Confirmed`, `Unconfirmed`, or `Cancelled` status. |
| Status actions | A confirmed appointment shows **Start Video Call**. An unconfirmed appointment shows **Cancel Appointment** with a confirmation dialog. A cancelled appointment is read-only. |
| Video call | The active call screen uses ZEGOCLOUD's WebRTC-based prebuilt Flutter SDK for a one-to-one room. It provides local/remote video, microphone and camera controls, camera switching, and end-call controls. |
| Session notes | Doctors can add, view, and delete appointment-scoped notes. Notes are stored in and streamed from Cloud Firestore, newest first. |

## Tech stack

- Flutter and Dart
- Firebase Authentication for doctor sign-in
- Cloud Firestore for session notes
- Provider / `ChangeNotifier` for app state
- ZEGOCLOUD `zego_uikit_prebuilt_call` for the active WebRTC call UI
- `flutter_webrtc` for an additional Firestore-signalled peer-connection service
- Material 3, `flutter_screenutil`, and `intl`

## Architecture

The project uses a feature-first structure and separates UI, state, data access, and models:

```text
lib/
├── app/                         # App shell and route constants
├── core/                        # Shared configuration, constants, utilities, widgets
├── features/
│   ├── auth/                    # Firebase sign-in, provider, login screen
│   ├── appointments/            # Appointment model, provider, dashboard/details
│   ├── notes/                   # Firestore CRUD, provider, add/list screens
│   └── vediocalls/              # ZEGOCLOUD call UI and raw WebRTC service
├── firebase_options.dart         # FlutterFire-generated Firebase configuration
└── main.dart                    # Firebase and Provider bootstrap
```

The primary dependency flow is:

```text
View → Provider (state and UI errors) → Service (Firebase/WebRTC) → Model
```

This keeps Firebase and signalling code out of widgets while allowing loading and error states to be rendered by the UI.

## Prerequisites

- Flutter SDK compatible with Dart `^3.9.2`
- A Firebase project with Authentication and Cloud Firestore enabled
- A ZEGOCLOUD project for video calling
- A physical device or emulator with camera/microphone access for call testing

## Setup and run

1. Install packages:

   ```bash
   flutter pub get
   ```

2. Configure Firebase.

   The repository includes Firebase configuration files. To connect it to a different Firebase project, run:

   ```bash
   flutterfire configure
   ```

   In Firebase Console, enable **Authentication → Email/Password** and create a doctor user. The login screen is prefilled with `doctor@telecare.com` and `Doctor@123`; use those values only if that account exists in your Firebase project.

3. Configure ZEGOCLOUD.

   Put your ZEGOCLOUD App ID and App Sign in the active call screen at `lib/features/vediocalls/views/video_call_screen.dart`. Do not commit production credentials; prefer `--dart-define` or another secret-management mechanism for a real deployment.

4. Run the app:

   ```bash
   flutter run
   ```

## Firebase data

Session notes are stored in the top-level `session_notes` collection:

```text
session_notes/{noteId}
  appointmentId: string
  doctorId: string
  note: string
  createdAt: Timestamp
```

The sample appointment is currently local state in `AppointmentProvider` (`APT-2026-001`), so its cancellation state is not persisted after an app restart. Notes are persisted to Firestore.

## Test the complete workflow

1. Sign in with an enabled Firebase Email/Password account.
2. Open the upcoming appointment from the dashboard.
3. Confirm the patient information and appointment status.
4. Tap **Session Notes** to add a note, return to verify it appears, and optionally delete it.
5. With the default confirmed sample appointment, tap **Start Video Call**.
6. On a second device or app instance, join the same appointment room (`appointment_APT-2026-001`). Each instance creates a distinct user ID, allowing ZEGOCLOUD to connect the participants.

## Video-call implementation note

`VideoCallScreen` is the production-facing path used by the appointment screen. It uses ZEGOCLOUD's prebuilt one-to-one WebRTC UI, which supplies the required media views and controls.

`lib/features/vediocalls/services/video_call_service.dart` also contains a custom `flutter_webrtc` implementation with Cloud Firestore offer/answer and ICE-candidate signalling. It exposes local and remote renderers plus microphone, camera, camera-switch, and end-call methods. This service is not currently connected to the visible call screen; it is a separate reference implementation rather than a second selectable call flow.

## Platform permissions

- Android requests `INTERNET`, `CAMERA`, `RECORD_AUDIO`, and `MODIFY_AUDIO_SETTINGS` in `android/app/src/main/AndroidManifest.xml`.
- iOS provides camera and microphone usage descriptions in `ios/Runner/Info.plist`.

## Quality checks

```bash
flutter analyze
flutter test
```

`flutter analyze` passes with no issues in the current project.

## Known limitations and next steps

- The dashboard intentionally contains one in-memory sample appointment; a production app should load appointments and status changes from Firestore or an API.
- Firestore security rules should restrict notes and video signalling to the appropriate doctor and patient.
- Move ZEGOCLOUD credentials out of source control before distribution.
- Add unit and widget tests for validation, providers, and key UI states.
- Connect the custom WebRTC service to a dedicated UI only if a custom call experience is required; otherwise keep the maintained SDK path as the single call implementation.
