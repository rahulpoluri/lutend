# Implementation Plan

## Phase 1: Monorepo Setup and Infrastructure

- [x] 1. Restructure project as monorepo
  - Move existing frontend to web/ directory
  - Keep backend/ directory as is
  - Create mobile/ directory for React Native app
  - Create admin/ directory for admin dashboard (separate from web)
  - Create infrastructure/ directory for Terraform
  - Create shared/ directory for shared code
  - Set up PNPM workspaces configuration
  - Update root package.json with workspace scripts
  - _Requirements: F1_

- [x] 1.5 Update documentation for PNPM and monorepo setup
  - Update README.md with comprehensive PNPM installation and usage
  - Update development.md with PNPM-specific commands and workflows
  - Update web/README.md to use PNPM instead of npm
  - Update backend/README.md with monorepo context
  - Create PNPM-GUIDE.md with detailed PNPM commands and troubleshooting
  - Update all package.json scripts documentation
  - Add PNPM workspace examples and best practices
  - Document dependency management in monorepo
  - Add troubleshooting section for common PNPM issues
  - _Requirements: F1, F6_

- [ ] 2. Enhance development environment
  - Add Redis service to docker-compose.yml
  - Add MinIO or S3-compatible storage to docker-compose.yml
  - Update backend to connect to Redis
  - Configure shared TypeScript configuration
  - Update ESLint and Prettier for monorepo
  - Update pre-commit hooks for all workspaces
  - _Requirements: F1, F4_

- [ ] 3. Set up shared packages infrastructure
  - [ ] 3.1 Create shared types package
    - Set up shared/types directory structure
    - Configure openapi-typescript for type generation
    - Create script to regenerate types from backend OpenAPI
    - _Requirements: F2_

  - [ ] 3.2 Create shared API client package
    - Set up shared/api-client directory
    - Configure openapi-typescript-codegen or similar
    - Generate type-safe API client from OpenAPI spec
    - Add authentication and error handling to client
    - _Requirements: F2_

  - [ ] 3.3 Extract and create design system
    - Create shared/design-tokens directory
    - Extract design tokens from Figma (colors, typography, spacing, shadows)
    - Create token files (colors.ts, typography.ts, spacing.ts, etc.)
    - Set up shared/components for reusable UI components
    - Configure Storybook for component documentation
    - _Requirements: F3_

## Phase 2: Backend Extensions

- [ ] 4. Add Redis integration to backend
  - Install Redis client library (redis-py or aioredis)
  - Create Redis connection configuration in core/config.py
  - Create Redis service wrapper in core/redis.py
  - Add Redis dependency injection
  - _Requirements: A12_

- [ ] 5. Extend authentication system for phone OTP
  - [ ] 5.1 Add phone number to User model
    - Add phone_number field to User model
    - Create Alembic migration for phone_number column
    - Make phone_number unique and indexed
    - _Requirements: A1_

  - [ ] 5.2 Implement OTP authentication
    - Create OTP generation utility
    - Store OTP in Redis with 5-minute expiration
    - Integrate SMS provider API (Twilio, AWS SNS, or similar)
    - Create POST /auth/send-otp endpoint
    - Create POST /auth/verify-otp endpoint
    - _Requirements: A1_

  - [ ] 5.3 Implement social login
    - Add social_accounts table model
    - Create OAuth2 integration for Google
    - Create OAuth2 integration for Facebook
    - Create OAuth2 integration for Apple
    - Create OAuth2 integration for X (Twitter)
    - Create POST /auth/link-social endpoint
    - Create POST /auth/login/social endpoint
    - _Requirements: A1_

- [ ] 6. Implement user profile and preferences system
  - [ ] 6.1 Create profile models
    - Create user_profiles table model with extended fields
    - Create user_preferences table with priority ordering
    - Create user_questions table (max 3 questions)
    - Create Alembic migrations
    - _Requirements: A2_

  - [ ] 6.2 Implement profile service
    - Create profile CRUD service methods
    - Add profile field validation
    - Implement approval workflow for sensitive changes
    - _Requirements: A2_

  - [ ] 6.3 Implement preference service
    - Create preference CRUD service methods
    - Implement preference reordering logic
    - Validate top 3 mandatory preferences
    - Calculate weighted scores for remaining preferences
    - _Requirements: A2_

  - [ ] 6.4 Create profile API endpoints
    - GET /users/me/profile - Get user profile
    - PATCH /users/me/profile - Update profile
    - GET /users/me/preferences - Get preferences
    - PUT /users/me/preferences - Update and reorder preferences
    - GET /users/me/questions - Get user questions
    - PUT /users/me/questions - Update questions (max 3)
    - _Requirements: A2_

- [ ] 7. Implement onboarding system
  - [ ] 7.1 Create onboarding models
    - Define questionnaire structure (intent-based)
    - Create database schema for storing answers
    - Set up progress tracking
    - _Requirements: A3_

  - [ ] 7.2 Implement onboarding service
    - Create service to fetch questions based on intent
    - Implement answer validation and storage
    - Calculate completion progress
    - Allow partial completion and resume
    - _Requirements: A3_

  - [ ] 7.3 Create onboarding API endpoints
    - GET /onboarding/questions - Get questions by intent
    - POST /onboarding/answers - Save answers
    - GET /onboarding/progress - Get completion status
    - _Requirements: A3_

- [ ] 8. Implement verification system
  - [ ] 8.1 Set up S3 integration
    - Configure S3 or MinIO client
    - Create upload utility functions
    - Set up signed URL generation for secure uploads
    - _Requirements: A4_

  - [ ] 8.2 Create verification models
    - Create verification_materials table
    - Create Alembic migration
    - _Requirements: A4_

  - [ ] 8.3 Implement photo upload and avatar generation
    - Create POST /verification/photos endpoint
    - Integrate AI service API for avatar generation
    - Create POST /verification/generate-avatars endpoint
    - Implement regeneration logic (one-time use)
    - Create POST /verification/regenerate-avatars endpoint
    - Create POST /verification/select-avatar endpoint
    - _Requirements: A4_

  - [ ] 8.4 Implement verification workflow
    - Create verification submission endpoint
    - Implement admin review queue
    - Add verification status updates
    - Send notifications on approval/rejection
    - Create POST /verification/submit endpoint
    - _Requirements: A4_

- [ ] 9. Implement matching algorithm and search system
  - [ ] 9.1 Create matching models
    - Create matches table with compatibility scores
    - Create search_sessions table
    - Create Alembic migrations
    - _Requirements: A5_

  - [ ] 9.2 Implement matching algorithm
    - Create compatibility scoring logic
    - Implement mandatory preference validation (top 3)
    - Calculate weighted scores for remaining preferences
    - Add location-based filtering
    - _Requirements: A5_

  - [ ] 9.3 Implement search session management
    - Create search initiation logic
    - Track active searches per user (max 3)
    - Implement background matching job with Celery or similar
    - Handle search expiration
    - _Requirements: A5_

  - [ ] 9.4 Create matching API endpoints
    - POST /matches/search - Initiate search
    - GET /matches/search/:id - Get search status
    - GET /matches/:id - Get match details
    - _Requirements: A5_

- [ ] 10. Implement meeting scheduling and lifecycle
  - [ ] 10.1 Create meeting models
    - Create match_timeslots table
    - Create meetings table with status tracking
    - Create Alembic migrations
    - _Requirements: A6_

  - [ ] 10.2 Implement scheduling service
    - Create timeslot submission logic
    - Implement mutual time selection
    - Handle voice note storage in S3
    - Process question answers
    - _Requirements: A6_

  - [ ] 10.3 Integrate video service
    - Set up WebRTC or Twilio integration
    - Generate video call credentials
    - Implement meeting recording storage
    - _Requirements: A6_

  - [ ] 10.4 Implement meeting lifecycle service
    - Create meeting join logic
    - Implement meeting extension requests
    - Track meeting duration and status
    - Handle disconnection and reconnection
    - _Requirements: A6_

  - [ ] 10.5 Create meeting API endpoints
    - POST /matches/:id/timeslots - Submit times
    - POST /matches/:id/confirm-time - Confirm meeting
    - POST /meetings/:id/join - Join meeting
    - POST /meetings/:id/extend - Request extension
    - _Requirements: A6_

- [ ] 11. Implement post-meeting feedback system
  - [ ] 11.1 Create feedback models
    - Create meeting_feedback table
    - Create Alembic migration
    - _Requirements: A7_

  - [ ] 11.2 Implement feedback service
    - Create feedback submission logic
    - Implement mutual action processing
    - Handle chat activation (30-day expiration)
    - Implement detail reveal with 12-hour delay
    - Process report submissions
    - _Requirements: A7_

  - [ ] 11.3 Create feedback API endpoint
    - POST /meetings/:id/feedback - Submit feedback and actions
    - _Requirements: A7_

- [ ] 12. Implement chat system
  - [ ] 12.1 Create chat models
    - Create chats table with expiration tracking
    - Create messages table
    - Create Alembic migrations
    - _Requirements: A8_

  - [ ] 12.2 Implement chat service
    - Create chat activation logic
    - Implement message storage and retrieval
    - Track last activity for ghosting detection (7 days)
    - Implement chat expiration background job (30 days)
    - _Requirements: A8_

  - [ ] 12.3 Implement WebSocket server
    - Set up WebSocket endpoint for real-time messaging
    - Implement connection management
    - Add typing indicators and presence
    - Handle message delivery and read receipts
    - _Requirements: A8_

  - [ ] 12.4 Create chat API endpoints
    - GET /chats - Get active and expired chats
    - GET /chats/:id/messages - Get message history
    - POST /chats/:id/messages - Send message
    - WS /ws/chats/:id - WebSocket connection
    - _Requirements: A8_

- [ ] 13. Implement content management system
  - [ ] 13.1 Create content models
    - Create content table for articles and videos
    - Create content_comments table with threading
    - Create Alembic migrations
    - _Requirements: A9_

  - [ ] 13.2 Implement content service
    - Create content feed with pagination
    - Implement comment and reply logic
    - Add user tagging in comments
    - Track engagement time
    - _Requirements: A9_

  - [ ] 13.3 Create content API endpoints
    - GET /content/feed - Get paginated content
    - POST /content/:id/comments - Create comment
    - POST /content/:id/comments/:commentId/replies - Create reply
    - GET /content/analytics - Get engagement metrics
    - _Requirements: A9_

- [ ] 14. Implement payment and credits system
  - [ ] 14.1 Create credit models
    - Create credit_transactions table
    - Create Alembic migration
    - _Requirements: A10_

  - [ ] 14.2 Implement credit service
    - Create credit balance tracking
    - Implement credit deduction logic
    - Add transaction recording
    - Handle refund processing (6-month rule)
    - _Requirements: A10_

  - [ ] 14.3 Integrate payment gateway
    - Set up Stripe integration
    - Implement payment processing
    - Handle payment webhooks
    - _Requirements: A10_

  - [ ] 14.4 Create payment API endpoints
    - GET /credits/balance - Get balance
    - GET /credits/offers - Get packages
    - POST /credits/purchase - Process purchase
    - POST /credits/refund - Request refund
    - _Requirements: A10_

- [ ] 15. Implement admin operations
  - [ ] 15.1 Create admin models
    - Create admin_actions table for audit log
    - Add admin role support to existing User model
    - Create Alembic migration
    - _Requirements: A11_

  - [ ] 15.2 Implement admin service
    - Create verification review logic
    - Implement user moderation (ban, warn, unban)
    - Add report review functionality
    - Create audit logging
    - _Requirements: A11_

  - [ ] 15.3 Create admin API endpoints
    - GET /admin/verifications/pending - Get queue
    - POST /admin/verifications/:id/approve - Approve
    - POST /admin/verifications/:id/reject - Reject
    - GET /admin/reports - Get reports
    - POST /admin/users/:id/ban - Ban user
    - POST /admin/users/:id/warn - Warn user
    - _Requirements: A11_

## Phase 3: Web App Extensions

- [ ] 16. Adapt existing web app for Lutend
  - Move existing frontend to web/ directory
  - Update imports and paths
  - Integrate shared types and API client packages
  - Update API client to use shared package
  - _Requirements: C1, F1_

- [ ] 17. Implement phone OTP authentication UI
  - Modify login page to support phone number input
  - Create OTP verification screen
  - Update authentication flow to use phone OTP
  - Keep existing email/password as fallback
  - _Requirements: C1_

- [ ] 18. Add social login buttons
  - Add Google login button with OAuth flow
  - Add Facebook login button with OAuth flow
  - Add Apple login button with OAuth flow
  - Add X (Twitter) login button with OAuth flow
  - _Requirements: C1_

- [ ] 19. Implement onboarding flow
  - Create location permission request page
  - Create intent selection page
  - Create questionnaire pages with multi-step form
  - Add progress bar and navigation
  - Implement form validation
  - Add skip functionality
  - _Requirements: C2_

- [ ] 20. Implement verification interface
  - Create photo upload page with drag-and-drop
  - Create avatar selection page
  - Add webcam access for video verification
  - Show upload progress indicators
  - Create waiting screen for admin review
  - _Requirements: C3_

- [ ] 21. Update dashboard navigation
  - Modify existing dashboard for Lutend sections
  - Add Meet, Profile, Content, Chat, Credits sections
  - Update sidebar navigation
  - Implement responsive layout
  - _Requirements: C4_

- [ ] 22. Implement meeting interface
  - Create match search page
  - Create match profile display page
  - Add calendar component for scheduling
  - Integrate WebRTC for video calling
  - Add meeting controls
  - _Requirements: C5_

- [ ] 23. Implement chat interface
  - Create WebSocket connection for real-time chat
  - Create chat list page
  - Create individual chat page
  - Add message composer with emoji picker
  - Show typing indicators and read receipts
  - Display expiration warnings
  - _Requirements: C6_

- [ ] 24. Implement profile and content pages
  - Create profile editor page
  - Create preference management page with drag-and-drop
  - Create content feed page
  - Add video player and article reader
  - Implement commenting system
  - _Requirements: C7_

- [ ] 25. Implement payment pages
  - Create credits page showing balance
  - Display credit packages and offers
  - Integrate Stripe payment form
  - Handle payment success/failure
  - Show transaction history
  - _Requirements: C8_

## Phase 4: Admin Dashboard (Separate App)

- [ ] 26. Create separate admin dashboard app
  - Initialize new React project in admin/ directory
  - Set up React Router
  - Configure state management
  - Integrate shared types and API client
  - Set up admin-specific styling
  - _Requirements: D1, F1_

- [ ] 27. Implement admin authentication
  - Create admin login page
  - Implement role-based access control
  - Add session timeout
  - Create audit logging display
  - _Requirements: D1_

- [ ] 28. Implement verification management
  - Create verification queue page
  - Display user verification materials
  - Add approve/reject buttons
  - Implement rejection message composer
  - Show verification statistics
  - _Requirements: D2_

- [ ] 29. Implement user management
  - Create user search page with filters
  - Display detailed user profiles
  - Add moderation actions (ban, warn, unban)
  - Show user reports with meeting logs
  - Implement bulk actions
  - _Requirements: D3_

- [ ] 30. Implement content management
  - Create rich text editor for articles
  - Implement video upload interface
  - Add content scheduling
  - Display content analytics
  - Implement comment moderation
  - _Requirements: D4_

- [ ] 31. Implement analytics dashboard
  - Create dashboard with key metrics
  - Add date range filters and export
  - Display charts for growth and revenue
  - Implement funnel analysis
  - Add real-time monitoring
  - _Requirements: D5_

- [ ] 32. Implement support ticket management
  - Create ticket queue page
  - Display ticket details with context
  - Add response composer
  - Implement ticket assignment
  - Track response times
  - _Requirements: D6_

- [ ] 33. Implement payment management
  - Display transaction history
  - Add manual credit adjustment
  - Implement refund processing
  - Show payment reconciliation
  - Add promotional credit tools
  - _Requirements: D7_

## Phase 5: React Native Mobile App

- [ ] 34. Initialize React Native mobile app
  - [ ] 34.1 Set up React Native project
    - Initialize React Native project in mobile/ directory
    - Configure iOS project
    - Configure Android project
    - Set up React Navigation
    - Configure state management (Redux Toolkit or Zustand)
    - _Requirements: B1, F1_

  - [ ] 34.2 Integrate shared packages
    - Install shared types and API client packages
    - Configure shared design tokens for React Native
    - Set up shared components for React Native
    - _Requirements: F2, F3_

  - [ ] 34.3 Configure mobile services
    - Set up secure storage (Keychain/Keystore)
    - Configure Firebase Cloud Messaging
    - Set up deep linking
    - Configure camera and media permissions
    - _Requirements: B10_

- [ ] 35. Implement mobile authentication
  - Create welcome screen with logo animation
  - Create phone number input screen
  - Create OTP verification screen
  - Add social login buttons
  - Implement secure token storage
  - _Requirements: B1_

- [ ] 36. Implement mobile onboarding
  - Create location permission screen
  - Create intent selection screen
  - Create questionnaire screens with progress
  - Add back navigation
  - Implement skip functionality
  - _Requirements: B2_

- [ ] 37. Implement mobile verification
  - Create photo upload screen with camera/gallery
  - Create avatar selection screen
  - Add regenerate button
  - Create video verification screen
  - Create ID scan screen
  - Add waiting screen
  - _Requirements: B3_

- [ ] 38. Implement mobile dashboard
  - Create bottom tab navigator
  - Implement first-time tutorial
  - Add push notification badges
  - Configure deep linking
  - Handle background state
  - _Requirements: B4_

- [ ] 39. Implement mobile meeting flow
  - Create match search screen
  - Create match profile screen
  - Create calendar picker
  - Add voice note recording
  - Implement video call screen with WebRTC
  - Add video controls
  - Handle reconnection
  - _Requirements: B5_

- [ ] 40. Implement mobile chat
  - Create post-meeting feedback screen
  - Create chat list screen
  - Create individual chat screen
  - Integrate WebSocket
  - Show expiration warnings
  - _Requirements: B6_

- [ ] 41. Implement mobile profile and preferences
  - Create profile view/edit screen
  - Create preference management with drag-and-drop
  - Highlight top 3 preferences
  - Show approval status
  - _Requirements: B7_

- [ ] 42. Implement mobile content feed
  - Create content feed screen
  - Implement video player
  - Add commenting functionality
  - Implement user tagging
  - Track time spent
  - _Requirements: B8_

- [ ] 43. Implement mobile credits and payment
  - Create credits screen
  - Display packages and offers
  - Integrate iOS In-App Purchase
  - Integrate Google Play Billing
  - Show transaction history
  - _Requirements: B9_

## Phase 6: Infrastructure and Deployment

- [ ] 44. Set up Terraform infrastructure
  - [ ] 44.1 Create Terraform structure
    - Set up infrastructure/ directory
    - Create module structure (compute, database, networking, storage, cache, monitoring)
    - Create provider abstraction (AWS, GCP, Azure)
    - Set up environment configs (dev, staging, production)
    - _Requirements: E1, F1_

  - [ ] 44.2 Configure state management
    - Set up remote state backend
    - Configure state locking
    - Create workspace for each environment
    - _Requirements: E1_

- [ ] 45. Implement container orchestration
  - Create compute module for ECS/GKE/AKS
  - Configure container registry
  - Set up task/pod definitions
  - Implement auto-scaling policies
  - Configure health checks
  - _Requirements: E1_

- [ ] 46. Implement database infrastructure
  - Create database module for PostgreSQL
  - Configure automated backups
  - Set up read replicas
  - Implement encryption
  - Configure multi-AZ deployment
  - _Requirements: E2_

- [ ] 47. Implement cache infrastructure
  - Create cache module for Redis
  - Configure cluster mode
  - Set up automatic failover
  - Implement encryption and authentication
  - _Requirements: E2_

- [ ] 48. Implement storage infrastructure
  - Create storage module for S3/GCS/Blob
  - Configure lifecycle policies
  - Set up versioning
  - Implement CORS configuration
  - Configure CDN integration
  - _Requirements: E2_

- [ ] 49. Implement networking infrastructure
  - Create VPC with subnets
  - Configure NAT gateways
  - Set up application load balancer
  - Implement SSL/TLS termination
  - Configure security groups
  - Add WAF rules
  - _Requirements: E3_

- [ ] 50. Implement monitoring infrastructure
  - Create monitoring module
  - Configure centralized logging
  - Set up metrics collection
  - Create alerting rules
  - Implement distributed tracing
  - Configure log retention
  - _Requirements: E4_

- [ ] 51. Implement CI/CD pipelines
  - Create container registry
  - Configure build pipeline
  - Set up deployment pipelines
  - Implement automated rollback
  - Configure deployment strategies
  - _Requirements: E5_

- [ ] 52. Implement security infrastructure
  - Create secrets management
  - Configure IAM roles and policies
  - Set up encryption keys
  - Implement certificate management
  - Configure security scanning
  - _Requirements: E6_

- [ ] 53. Implement backup and disaster recovery
  - Configure automated backups
  - Set up cross-region replication
  - Implement backup retention policies
  - Create disaster recovery runbooks
  - Configure infrastructure snapshots
  - _Requirements: E7_

## Phase 7: CI/CD and Documentation

- [ ] 54. Update CI/CD workflows
  - [ ] 54.1 Update backend CI/CD
    - Extend existing GitHub Actions workflow
    - Add new endpoint tests
    - Update deployment for new services
    - _Requirements: F5_

  - [ ] 54.2 Create mobile CI/CD
    - Set up GitHub Actions for mobile
    - Configure iOS build
    - Configure Android build
    - Implement deployment to TestFlight and Play Console
    - _Requirements: F5_

  - [ ] 54.3 Update web CI/CD
    - Extend existing workflow for web app
    - Update deployment configuration
    - _Requirements: F5_

  - [ ] 54.4 Create admin CI/CD
    - Set up GitHub Actions for admin
    - Configure build and deployment
    - _Requirements: F5_

  - [ ] 54.5 Create infrastructure CI/CD
    - Set up Terraform validation workflow
    - Add security scanning with tfsec
    - Implement cost estimation
    - Configure deployment approval
    - _Requirements: F5_

- [ ] 55. Create documentation
  - [ ] 55.1 Write architecture documentation
    - Create architecture decision records
    - Document system architecture
    - Add component diagrams
    - _Requirements: F6_

  - [ ] 55.2 Update API documentation
    - Document new endpoints
    - Add authentication guides
    - Create error handling docs
    - _Requirements: F6_

  - [ ] 55.3 Write deployment documentation
    - Create deployment runbooks
    - Document rollback procedures
    - Add troubleshooting guides
    - _Requirements: F6_

  - [ ] 55.4 Write development guides
    - Update getting started guide
    - Document local development setup
    - Add contribution guidelines
    - _Requirements: F6_

- [ ] 56. Configure environment management
  - Update .env files for new services
  - Create .env.example templates
  - Implement environment variable validation
  - Document all environment variables
  - _Requirements: F7_
