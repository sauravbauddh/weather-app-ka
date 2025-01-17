import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:get/get.dart';
import 'package:weather_app/network/api_end_points.dart';

class AppWriteController extends GetxController {
  late Client client;
  final String bucketId = '678930fd003892f210e7';
  final String projectId = '6788e83600241d9c787e';
  final String dbId = '678944f9000ff5102e99';
  final String bannerInfoCollectionId = '678945130003c53e5bb9';

  @override
  void onInit() {
    super.onInit();
    client = Client()
      ..setProject(projectId)
      ..setEndpoint(ApiEndPoints.appWriteBaseUrl);
  }

  Future<DocumentList> getDocumentList(String collectionId) async {
    Databases databases = Databases(client);

    return await databases.listDocuments(
      collectionId: collectionId,
      databaseId: dbId,
    );
  }

  Future<DocumentList> getBannerInfo() async {
    return await getDocumentList(bannerInfoCollectionId);
  }

  String getFileUrl(String fileId) {
    return '${client.endPoint}/storage/buckets/$bucketId/files/$fileId/view?project=$projectId';
  }
}
