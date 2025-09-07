# Accessing the Deployed Full-Stack Authentication Application

Once the deployment to Azure Container Apps is complete, you can access the application using the following URLs:

## Frontend Application

The frontend application will be available at:
```
https://frontend-auth.REGION.azurecontainerapps.io
```

This URL will be displayed at the end of the deployment script output.

## Backend API

The backend API will be available at:
```
https://backend-auth.REGION.azurecontainerapps.io
```

This URL will also be displayed at the end of the deployment script output.

## Testing Authentication

1. Open the frontend URL in your browser
2. Navigate to the registration page by clicking "Sign Up"
3. Create a new account with your email and password
4. Check your email for a verification link (if email service is configured)
5. Log in with your credentials
6. You should now have access to the protected dashboard page

## API Endpoints

The backend API provides the following authentication endpoints:

### Public Endpoints

- `GET /api/health` - Health check endpoint
- `POST /api/auth/register` - Register a new user
- `POST /api/auth/[...nextauth]/` - NextAuth.js authentication
- `POST /api/auth/forgot-password` - Request password reset
- `POST /api/auth/reset-password` - Reset password with token
- `GET /api/auth/verify-email` - Verify email address with token

### Protected Endpoints

- `GET /api/admin` - Admin-only endpoint (requires admin role)
- `GET /dashboard` - Protected user dashboard

## Troubleshooting

If you encounter issues accessing the application:

1. **Check Deployment Status**: Run `.\monitor-deployment.ps1` to verify all components are deployed successfully
2. **Check Container Health**: In Azure Portal, navigate to your Container Apps and check the health status
3. **View Container Logs**: In Azure Portal, navigate to your Container Apps > Logs to see application logs
4. **Check Environment Variables**: Verify that the environment variables, especially `BACKEND_URL` in the frontend app, are correctly configured

## Common Issues

### CORS Errors

If you see CORS errors in the browser console, verify that:
- The frontend is correctly configured with the backend URL
- The backend CORS configuration includes the frontend URL

### Authentication Failures

If authentication isn't working:
- Check the backend logs for errors
- Verify that Auth.js is correctly configured
- Ensure the database migrations have been applied

### Database Connection Issues

If the backend can't connect to the database:
- Check the connection string in the environment variables
- Verify that the database server allows connections from Azure Container Apps

## Next Steps

After confirming the application is working correctly in production, you may want to:

1. Set up a custom domain name for your frontend and backend
2. Configure SSL certificates for your custom domains
3. Set up monitoring and alerts for your Container Apps
4. Implement CI/CD pipelines for automated deployments
