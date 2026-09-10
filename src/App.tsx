import { BrowserRouter, Navigate, Route, Routes } from 'react-router-dom'
import { AuthProvider } from './contexts/AuthContext'
import { ProtectedRoute } from './routes/ProtectedRoute'
import { StudentShell } from './components/layout/StudentShell'
import { InstructorShell } from './components/layout/InstructorShell'
import { WelcomeVideoGate } from './components/WelcomeVideoGate'
import { Landing } from './pages/Landing'
import { Login } from './pages/Login'
import { Signup } from './pages/Signup'
import { PendingApproval } from './pages/PendingApproval'
import { Home } from './pages/Home'
import { Learn } from './pages/Learn'
import { Search } from './pages/Search'
import { LessonViewer } from './pages/LessonViewer'
import { Practice } from './pages/Practice'
import { Progress } from './pages/Progress'
import { AskAI } from './pages/AskAI'
import { AssignmentPage } from './pages/AssignmentPage'
import { TrackDiscussion } from './pages/TrackDiscussion'
import { AdminHome } from './pages/admin/AdminHome'
import { Approvals } from './pages/admin/Approvals'
import { Bundles } from './pages/admin/Bundles'
import { Grading } from './pages/admin/Grading'
import { Cohorts } from './pages/admin/Cohorts'
import { Students } from './pages/admin/Students'
import { ContentFeedback } from './pages/admin/ContentFeedback'
import { Analytics } from './pages/admin/Analytics'
import { AuditLog } from './pages/admin/AuditLog'
import { Team } from './pages/admin/Team'
import { Discussions } from './pages/admin/Discussions'
import { TracksList } from './pages/admin/curriculum/TracksList'
import { TrackDetail } from './pages/admin/curriculum/TrackDetail'
import { ModuleDetail } from './pages/admin/curriculum/ModuleDetail'
import { LessonDetail } from './pages/admin/curriculum/LessonDetail'

function App() {
  return (
    <AuthProvider>
      <BrowserRouter>
        <Routes>
          <Route path="/" element={<Landing />} />
          <Route path="/login" element={<Login />} />
          <Route path="/signup" element={<Signup />} />

          <Route
            path="/pending"
            element={
              <ProtectedRoute role="student" requireApproval={false}>
                <PendingApproval />
              </ProtectedRoute>
            }
          />

          <Route
            element={
              <ProtectedRoute role="student">
                <WelcomeVideoGate>
                  <StudentShell />
                </WelcomeVideoGate>
              </ProtectedRoute>
            }
          >
            <Route path="/home" element={<Home />} />
            <Route path="/learn" element={<Learn />} />
            <Route path="/search" element={<Search />} />
            <Route path="/practice" element={<Practice />} />
            <Route path="/progress" element={<Progress />} />
            <Route path="/ask-ai" element={<AskAI />} />
            <Route path="/learn/discussion/:trackId" element={<TrackDiscussion />} />
          </Route>

          <Route
            path="/learn/:trackSlug/:moduleSlug/:lessonSlug"
            element={
              <ProtectedRoute role="student">
                <LessonViewer />
              </ProtectedRoute>
            }
          />

          <Route
            path="/learn/assignment/:assignmentId"
            element={
              <ProtectedRoute role="student">
                <AssignmentPage />
              </ProtectedRoute>
            }
          />

          <Route
            path="/admin"
            element={
              <ProtectedRoute role="instructor">
                <InstructorShell />
              </ProtectedRoute>
            }
          >
            <Route index element={<AdminHome />} />
            <Route path="approvals" element={<Approvals />} />
            <Route path="cohorts" element={<Cohorts />} />
            <Route path="students" element={<Students />} />
            <Route path="bundles" element={<Bundles />} />
            <Route path="grading" element={<Grading />} />
            <Route path="content-feedback" element={<ContentFeedback />} />
            <Route path="discussions" element={<Discussions />} />
            <Route path="analytics" element={<Analytics />} />
            <Route path="audit-log" element={<AuditLog />} />
            <Route path="team" element={<Team />} />
            <Route path="curriculum" element={<TracksList />} />
            <Route path="curriculum/:trackSlug" element={<TrackDetail />} />
            <Route path="curriculum/:trackSlug/:moduleSlug" element={<ModuleDetail />} />
            <Route
              path="curriculum/:trackSlug/:moduleSlug/:lessonSlug"
              element={<LessonDetail />}
            />
          </Route>

          <Route path="*" element={<Navigate to="/" replace />} />
        </Routes>
      </BrowserRouter>
    </AuthProvider>
  )
}

export default App
