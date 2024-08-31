abstract class MyError {
  dynamic error;
}

class ApiError extends MyError {
  ApiError({required dynamic apiError}) {
    error = apiError;
  }
}

class DatabaseError extends MyError {
  DatabaseError({required dynamic dbError}) {
    error = dbError;
  }
}
