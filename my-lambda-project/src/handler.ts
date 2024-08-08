// src/handler.ts
import { APIGatewayProxyEvent, APIGatewayProxyResult } from "aws-lambda";

export const helloWorld = async (
  event: APIGatewayProxyEvent
): Promise<APIGatewayProxyResult> => {
  return {
    statusCode: 200,
    body: JSON.stringify({
      message: "Hello, World!",
      input: event
    })
  };
};

